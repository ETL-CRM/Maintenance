-- =====================================================================
-- Enam Trims Ltd — Maintenance ERP — Supabase schema
-- Run this once in your Supabase project's SQL Editor (Database → SQL Editor → New query)
-- =====================================================================

-- One table holds every module's data as a JSON list, keyed by module name.
-- This matches exactly how the app reads/writes its data (Machines, Sections,
-- PM, Breakdowns, Spare Parts, Repair Costs, Risk Register, Users).
create table if not exists erp_store (
  key         text primary key,
  value       jsonb not null default '[]'::jsonb,
  updated_at  timestamptz not null default now()
);

-- Row Level Security — required by Supabase before any policy takes effect.
alter table erp_store enable row level security;

-- This app does its own username/password check inside the browser (not
-- Supabase Auth), so every request comes in using the public "anon" key.
-- These policies let that anon key read and write this one table, and
-- nothing else in your project. Anyone who has your app's URL can reach
-- this table with the anon key (it's visible in the page source — that's
-- normal for Supabase's client-side apps), so treat this the same way you'd
-- treat an internal tool on your own network: fine for day-to-day use across
-- your team, but not a place to store anything you wouldn't want a
-- technically curious outsider to stumble onto.
create policy "erp_store: anon can read" on erp_store
  for select using (true);

create policy "erp_store: anon can write" on erp_store
  for insert with check (true);

create policy "erp_store: anon can update" on erp_store
  for update using (true);

create policy "erp_store: anon can delete" on erp_store
  for delete using (true);

-- That's it — no other tables needed. The app creates its own rows
-- (data_users, data_machines, data_sections, data_pm, data_breakdown,
-- data_stock, data_spareuse, data_sparereq, data_repair, data_risk)
-- automatically the first time each is saved.
