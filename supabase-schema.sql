-- ============================================
-- KADO AI Secretary — Supabase Schema
-- Run this once in: Supabase Dashboard -> SQL Editor -> New query -> Run
-- This sets up private, per-account storage using Supabase Auth + Row Level Security.
-- Nobody (not even with the public anon key) can read another account's data.
-- ============================================

-- 1. TASKS
create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  text text not null,
  category text not null default 'personal',
  done boolean not null default false,
  created_at timestamptz not null default now()
);
alter table public.tasks enable row level security;
create policy "tasks_select_own" on public.tasks for select using (auth.uid() = user_id);
create policy "tasks_insert_own" on public.tasks for insert with check (auth.uid() = user_id);
create policy "tasks_update_own" on public.tasks for update using (auth.uid() = user_id);
create policy "tasks_delete_own" on public.tasks for delete using (auth.uid() = user_id);

-- 2. EXPENSES / INCOME
create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  description text not null,
  amount numeric not null,
  type text not null check (type in ('income','expense')),
  created_at timestamptz not null default now()
);
alter table public.expenses enable row level security;
create policy "expenses_select_own" on public.expenses for select using (auth.uid() = user_id);
create policy "expenses_insert_own" on public.expenses for insert with check (auth.uid() = user_id);
create policy "expenses_update_own" on public.expenses for update using (auth.uid() = user_id);
create policy "expenses_delete_own" on public.expenses for delete using (auth.uid() = user_id);

-- 3. REMINDERS / ALARMS
create table if not exists public.reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  time text not null,
  text text not null,
  fired boolean not null default false,
  created_at timestamptz not null default now()
);
alter table public.reminders enable row level security;
create policy "reminders_select_own" on public.reminders for select using (auth.uid() = user_id);
create policy "reminders_insert_own" on public.reminders for insert with check (auth.uid() = user_id);
create policy "reminders_update_own" on public.reminders for update using (auth.uid() = user_id);
create policy "reminders_delete_own" on public.reminders for delete using (auth.uid() = user_id);

-- 4. CHAT HISTORY
create table if not exists public.chat_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  role text not null check (role in ('user','assistant')),
  content text not null,
  created_at timestamptz not null default now()
);
alter table public.chat_history enable row level security;
create policy "chat_select_own" on public.chat_history for select using (auth.uid() = user_id);
create policy "chat_insert_own" on public.chat_history for insert with check (auth.uid() = user_id);
create policy "chat_delete_own" on public.chat_history for delete using (auth.uid() = user_id);

-- 5. SETTINGS (language, theme, challenge index, life-balance sliders)
create table if not exists public.settings (
  user_id uuid references auth.users(id) on delete cascade not null,
  key text not null,
  value text not null,
  primary key (user_id, key)
);
alter table public.settings enable row level security;
create policy "settings_select_own" on public.settings for select using (auth.uid() = user_id);
create policy "settings_insert_own" on public.settings for insert with check (auth.uid() = user_id);
create policy "settings_update_own" on public.settings for update using (auth.uid() = user_id);
create policy "settings_delete_own" on public.settings for delete using (auth.uid() = user_id);

-- ============================================
-- Done. Every table is locked to auth.uid() = user_id.
-- Only YOUR logged-in session can ever read or write YOUR rows.
-- ============================================
