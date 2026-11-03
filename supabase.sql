-- Выполните этот скрипт целиком в Supabase: SQL Editor -> New query -> Run.
create table if not exists public.camp_state (
  id integer primary key check (id = 1),
  state jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.camp_state enable row level security;

drop policy if exists "Public can read camp state" on public.camp_state;
create policy "Public can read camp state"
on public.camp_state for select
to anon, authenticated
using (true);

drop policy if exists "Public can create camp state" on public.camp_state;
create policy "Public can create camp state"
on public.camp_state for insert
to anon, authenticated
with check (id = 1);

drop policy if exists "Public can update camp state" on public.camp_state;
create policy "Public can update camp state"
on public.camp_state for update
to anon, authenticated
using (id = 1)
with check (id = 1);

grant select, insert, update on public.camp_state to anon, authenticated;

do $$
begin
  alter publication supabase_realtime add table public.camp_state;
exception
  when duplicate_object then null;
  when undefined_object then
    raise notice 'Publication supabase_realtime not found; enable Realtime for camp_state in Dashboard.';
end $$;
