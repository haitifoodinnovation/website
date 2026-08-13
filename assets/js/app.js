import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm";
import { SUPABASE_URL, SUPABASE_ANON_KEY } from "./supabase-config.js";

export const configured = !SUPABASE_URL.includes("PASTE");
export const sb = configured ? createClient(SUPABASE_URL, SUPABASE_ANON_KEY) : null;

export async function currentUser() {
  if (!sb) return null;
  const { data } = await sb.auth.getSession();
  return data.session ? data.session.user : null;
}
export async function myProfile() {
  const u = await currentUser();
  if (!u) return null;
  const { data } = await sb.from("profiles").select("*").eq("id", u.id).single();
  return data;
}
export function etb(n) {
  return n == null ? "on confirmation" : Number(n).toLocaleString("en-US") + " ETB";
}
export function esc(s) {
  return String(s ?? "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
}
export function banner(el, msg, ok) {
  el.innerHTML = `<div style="padding:.8rem 1rem;border-radius:9px;margin:.8rem 0;font-weight:600;
    background:${ok ? "#E8EFE8" : "#F8E6E6"};color:${ok ? "#1F4A32" : "#8A2020"}">${msg}</div>`;
}
