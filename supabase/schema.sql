-- Run once in Supabase SQL Editor. Each user can access only their own records.
create table public.rd_customers (
  id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null, phone text, account_number text, monthly_amount numeric(12,2) not null check (monthly_amount > 0),
  start_date date not null, active boolean not null default true, created_at timestamptz not null default now()
);
create table public.rd_payments (
  id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  customer_id uuid not null references public.rd_customers(id) on delete cascade, amount numeric(12,2) not null check (amount > 0),
  paid_on date not null, month_for date not null, notes text, created_at timestamptz not null default now(),
  unique (customer_id, month_for)
);
alter table public.rd_customers enable row level security;
alter table public.rd_payments enable row level security;
create policy "Owner can manage rd customers" on public.rd_customers for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Owner can manage rd payments" on public.rd_payments for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id and exists (select 1 from public.rd_customers c where c.id = customer_id and c.user_id = (select auth.uid())));
create index rd_customers_owner_name on public.rd_customers(user_id, name);
create index rd_payments_owner_date on public.rd_payments(user_id, paid_on desc);
