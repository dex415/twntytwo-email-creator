-- =============================================================================
-- TWNTY-TWO® Email Creator — saved templates
-- Run this on the TWNTY-TWO Supabase project, then paste the project URL +
-- anon key into the app's Settings dialog. Nothing else changes.
-- =============================================================================

create table if not exists public.tt_email_templates (
  id          text primary key,                     -- 'tpl_xxxxxxxx' from the app
  name        text not null default 'Untitled Email',
  kind        text not null default 'custom',        -- 'drop' | 'sale' | 'custom'
  settings    jsonb not null default '{}'::jsonb,    -- subject, preheader, header tag
  blocks      jsonb not null default '[]'::jsonb,    -- ordered block array
  created_by  text,                                  -- optional: who last touched it
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists tt_email_templates_updated_idx
  on public.tt_email_templates (updated_at desc);

create index if not exists tt_email_templates_kind_idx
  on public.tt_email_templates (kind);

-- Optional version history: every save snapshots the previous state so a
-- template can be rolled back after a bad edit.
create table if not exists public.tt_email_template_versions (
  id          bigserial primary key,
  template_id text not null references public.tt_email_templates(id) on delete cascade,
  name        text,
  settings    jsonb,
  blocks      jsonb,
  saved_at    timestamptz not null default now()
);

create index if not exists tt_email_template_versions_tpl_idx
  on public.tt_email_template_versions (template_id, saved_at desc);

-- ---------------------------------------------------------------------------
-- keep updated_at honest + snapshot the prior row on every update
-- ---------------------------------------------------------------------------
create or replace function public.tt_email_templates_before_update()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.tt_email_template_versions (template_id, name, settings, blocks)
  values (old.id, old.name, old.settings, old.blocks);

  -- keep only the 20 most recent versions per template
  delete from public.tt_email_template_versions v
  where v.template_id = old.id
    and v.id not in (
      select id from public.tt_email_template_versions
      where template_id = old.id
      order by saved_at desc
      limit 20
    );

  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists tt_email_templates_versioning on public.tt_email_templates;
create trigger tt_email_templates_versioning
  before update on public.tt_email_templates
  for each row execute function public.tt_email_templates_before_update();

-- ---------------------------------------------------------------------------
-- RLS
-- The app talks to PostgREST with the ANON key from a browser, so the policy
-- below is what makes it work. Pick ONE of the two options.
-- ---------------------------------------------------------------------------
alter table public.tt_email_templates          enable row level security;
alter table public.tt_email_template_versions  enable row level security;

-- OPTION A — internal tool behind a shared link (simplest; anon can read/write).
-- Only use this if the Supabase project is not otherwise public.
drop policy if exists tt_email_templates_anon_all on public.tt_email_templates;
create policy tt_email_templates_anon_all
  on public.tt_email_templates
  for all
  to anon, authenticated
  using (true)
  with check (true);

drop policy if exists tt_email_template_versions_anon_read on public.tt_email_template_versions;
create policy tt_email_template_versions_anon_read
  on public.tt_email_template_versions
  for select
  to anon, authenticated
  using (true);

-- OPTION B — recommended once there are real logins. Comment out Option A,
-- uncomment this, and have the app pass a Supabase session JWT instead of anon.
--
-- drop policy if exists tt_email_templates_anon_all on public.tt_email_templates;
-- create policy tt_email_templates_authed_all
--   on public.tt_email_templates
--   for all
--   to authenticated
--   using (true)
--   with check (true);
