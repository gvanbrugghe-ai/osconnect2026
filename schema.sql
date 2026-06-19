-- ============================================================
--  OS Connect · Gartner Review sign-up tool — Supabase schema
--  Run this in: Supabase dashboard → SQL Editor → New query → Run
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

-- Faster sorting by brand
create index if not exists customers_brand_idx on public.customers (brand);

-- ---------- Row Level Security ----------
-- The app uses the public "anon" key (it is exposed in any static site,
-- this is normal for Supabase). RLS controls what that key can do.
-- Here we allow reading the list and updating the two status flags.
-- Inserting/seeding data is done by you via the dashboard, not the app.
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

-- ---------- Sample data (delete these once you import the real list) ----------
insert into public.customers (brand, last_name, first_name, email, csm) values
  ('Bogner',            'Moreau',  'Léa',   'lea.moreau@bogner.example',     'Camille Dubois'),
  ('Bogner',            'Berg',    'Tomas', 't.berg@bogner.example',         'Marc Lefèvre'),
  ('APEX Tech',         'Khan',    'Nadia', 'nadia.khan@apex.example',       'Camille Dubois'),
  ('APEX Tech',         'Pratt',   'Owen',  'owen.pratt@apex.example',       'Sofia Rossi'),
  ('Northwind Apparel', 'Tan',     'Mei',   'mei.tan@northwind.example',     'Marc Lefèvre'),
  ('Northwind Apparel', 'Lambert', 'Hugo',  'hugo.lambert@northwind.example','Sofia Rossi'),
  ('Maison Clé',        'Faure',   'Inès',  'ines.faure@maisoncle.example',  'Camille Dubois');
