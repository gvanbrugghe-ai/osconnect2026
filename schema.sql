-- ============================================================
--  OS Connect · Gartner Review sign-up tool — Supabase schema
--  Step 1: run this in Supabase → SQL Editor → New query → Run
--  Step 2: import your customers from customers_template.csv
--          (Table Editor → customers → Insert → Import data from CSV)
-- ============================================================

create table if not exists public.customers (
  id          uuid primary key default gen_random_uuid(),
  brand       text not null,
  last_name   text not null,
  first_name  text not null,
  email       text,
  csm         text not null,          -- nom du CSM
  contacted   boolean not null default false,
  subscribed  boolean not null default false,
  updated_at  timestamptz not null default now()
);

-- Faster sorting / filtering by brand
create index if not exists customers_brand_idx on public.customers (brand);

-- ---------- Row Level Security ----------
-- The app uses the public "anon" key (exposed in any static site — this is
-- normal for Supabase). RLS controls what that key can do: read the list and
-- update the status flags + email. Loading the data is done by you via CSV
-- import in the dashboard, not by the app.
alter table public.customers enable row level security;

drop policy if exists "anon can read customers"   on public.customers;
drop policy if exists "anon can update customers" on public.customers;

create policy "anon can read customers"
  on public.customers for select
  to anon
  using (true);

create policy "anon can update customers"
  on public.customers for update
  to anon
  using (true)
  with check (true);

-- No sample rows here on purpose — load real data from the CSV (see README).
