-- Manga Flow user metadata schema (Supabase/Postgres)
-- Run in Supabase SQL editor.

-- Extensions
create extension if not exists "pgcrypto";

-- Library items
create table if not exists public.library_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid(),
  manga_id text not null,
  category_ids text[] not null default '{}'::text[],
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, manga_id)
);

alter table public.library_items enable row level security;

create policy "library_items_select_own"
on public.library_items for select
using (user_id = auth.uid());

create policy "library_items_insert_own"
on public.library_items for insert
with check (user_id = auth.uid());

create policy "library_items_update_own"
on public.library_items for update
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy "library_items_delete_own"
on public.library_items for delete
using (user_id = auth.uid());

create index if not exists library_items_user_updated_at_idx
on public.library_items (user_id, updated_at desc);

