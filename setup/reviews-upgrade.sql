-- Reviews upgrade : paste this whole file into Supabase -> SQL Editor -> snippet -> Run
create table if not exists public.reviews (
  id serial primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default '',
  city text default '',
  product text not null,
  rating int not null check (rating between 1 and 5),
  review text not null,
  approved boolean not null default false,
  created_at timestamptz default now()
);
alter table public.reviews enable row level security;
drop policy if exists "reviews_insert_own" on public.reviews;
create policy "reviews_insert_own" on public.reviews for insert
  with check (auth.uid() = user_id);
drop policy if exists "reviews_select" on public.reviews;
create policy "reviews_select" on public.reviews for select
  using (approved = true or auth.uid() = user_id or public.is_admin());
drop policy if exists "reviews_admin_update" on public.reviews;
create policy "reviews_admin_update" on public.reviews for update
  using (public.is_admin()) with check (public.is_admin());
drop policy if exists "reviews_admin_delete" on public.reviews;
create policy "reviews_admin_delete" on public.reviews for delete
  using (public.is_admin());
