-- Haiti Food Innovation ET : database setup
-- Paste this WHOLE file into Supabase -> SQL Editor -> New query -> Run.

-- 1. Profiles ---------------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text default '',
  phone text default '',
  role text not null default 'customer' check (role in ('customer','distributor','admin')),
  distributor_status text check (distributor_status in ('pending','approved')),
  created_at timestamptz default now()
);

create or replace function public.is_admin() returns boolean
language sql security definer set search_path = public as
$$ select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin') $$;

create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name, phone, distributor_status)
  values (new.id,
          coalesce(new.raw_user_meta_data->>'full_name',''),
          coalesce(new.raw_user_meta_data->>'phone',''),
          case when new.raw_user_meta_data->>'wants_distributor' = 'true' then 'pending' else null end);
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute function public.handle_new_user();

alter table public.profiles enable row level security;
drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles for select
  using (auth.uid() = id or public.is_admin());
drop policy if exists "profiles_admin_update" on public.profiles;
create policy "profiles_admin_update" on public.profiles for update
  using (public.is_admin()) with check (public.is_admin());

-- 2. Products ---------------------------------------------------------------
create table if not exists public.products (
  id serial primary key,
  name text not null,
  name_am text default '',
  unit text default '',
  price_etb numeric,
  wholesale boolean not null default false,
  available boolean not null default true,
  sort int not null default 100
);
alter table public.products enable row level security;
drop policy if exists "products_read_all" on public.products;
create policy "products_read_all" on public.products for select using (true);
drop policy if exists "products_admin_write" on public.products;
create policy "products_admin_write" on public.products for all
  using (public.is_admin()) with check (public.is_admin());

-- 3. Orders -----------------------------------------------------------------
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  ref text not null default ('HFI-' || upper(substr(md5(random()::text),1,6))),
  user_id uuid not null references auth.users(id),
  status text not null default 'pending_payment'
    check (status in ('pending_payment','payment_review','confirmed','delivered','cancelled')),
  customer_name text default '',
  phone text default '',
  delivery_location text default '',
  note text default '',
  total_etb numeric,
  payment_ref text default '',
  created_at timestamptz default now()
);
alter table public.orders enable row level security;
drop policy if exists "orders_insert_own" on public.orders;
create policy "orders_insert_own" on public.orders for insert
  with check (auth.uid() = user_id);
drop policy if exists "orders_select_own_or_admin" on public.orders;
create policy "orders_select_own_or_admin" on public.orders for select
  using (auth.uid() = user_id or public.is_admin());
drop policy if exists "orders_update" on public.orders;
create policy "orders_update" on public.orders for update
  using (public.is_admin() or (auth.uid() = user_id and status = 'pending_payment'))
  with check (public.is_admin() or (auth.uid() = user_id and status in ('pending_payment','payment_review')));

create table if not exists public.order_items (
  id serial primary key,
  order_id uuid not null references public.orders(id) on delete cascade,
  user_id uuid not null references auth.users(id),
  product_id int references public.products(id),
  product_name text not null,
  qty int not null check (qty > 0),
  price_etb numeric
);
alter table public.order_items enable row level security;
drop policy if exists "items_insert_own" on public.order_items;
create policy "items_insert_own" on public.order_items for insert
  with check (auth.uid() = user_id);
drop policy if exists "items_select_own_or_admin" on public.order_items;
create policy "items_select_own_or_admin" on public.order_items for select
  using (auth.uid() = user_id or public.is_admin());

-- 4. Settings (payment instructions shown to customers) ---------------------
create table if not exists public.settings (
  key text primary key,
  value text default ''
);
alter table public.settings enable row level security;
drop policy if exists "settings_read_all" on public.settings;
create policy "settings_read_all" on public.settings for select using (true);
drop policy if exists "settings_admin_write" on public.settings;
create policy "settings_admin_write" on public.settings for all
  using (public.is_admin()) with check (public.is_admin());

insert into public.settings (key, value) values
  ('telebirr_number', 'ENTER TELEBIRR NUMBER IN ADMIN DASHBOARD'),
  ('bank_details', 'ENTER BANK NAME, ACCOUNT NAME AND ACCOUNT NUMBER IN ADMIN DASHBOARD'),
  ('order_note', 'After payment, enter your transaction reference number on your order. We confirm within one business day.')
on conflict (key) do nothing;

-- 5. Seed products ----------------------------------------------------------
insert into public.products (name, name_am, unit, wholesale, sort) values
  ('Instant Teff Injera Flour', 'ፈጣን የጤፍ እንጀራ ዱቄት', '1 kg pouch', false, 10),
  ('Kocho Blended Flour', 'የቆጮ ቅልቅል ዱቄት', '1 kg pouch', false, 20),
  ('Premium Kocho Flour for Cookie Making', 'የቆጮ ዱቄት ለብስኩት ሥራ', '1 kg pouch', false, 30),
  ('Soft & Nutritious Biscuits', 'ለስላሳና ገንቢ ብስኩቶች', '250 g pouch', false, 40),
  ('Kocho Energy Bar', 'የቆጮ ኢነርጂ ባር', '80 g pouch', false, 50),
  ('Soft Delight Bites', 'Soft Delight መክሰስ', '250 g pouch', false, 60),
  ('Teff Injera', 'የጤፍ እንጀራ', 'per piece / pack', false, 70),
  ('Wheat Bread', 'የስንዴ ዳቦ', 'per piece', false, 80),
  ('Cakes', 'ኬኮች', 'per order', false, 90),
  ('Pure Kocho Flour', 'ንጹህ የቆጮ ዱቄት', '10 kg sack', true, 110),
  ('Kocho Cookies & Biscuits Flour', 'የቆጮ ብስኩት ዱቄት', '5 kg sack', true, 120),
  ('Kocho & Wheat Blend Flour', 'የቆጮና ስንዴ ቅልቅል ዱቄት', 'bulk sack', true, 130),
  ('Kocho & Teff Blend Flour', 'የቆጮና ጤፍ ቅልቅል ዱቄት', 'bulk sack', true, 140),
  ('Bulla Flour', 'የቡላ ዱቄት', 'bulk sack', true, 150)
on conflict do nothing;

-- 6. AFTER creating your own account on the website, make it admin:
--    (replace the email if you register with a different one, then run just this line)
-- update public.profiles set role='admin'
--   where id = (select id from auth.users where email = 'haitifoodinnovationET@gmail.com');
