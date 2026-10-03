create table public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null default current_date,
  description text not null,
  amount numeric not null check (amount > 0),
  currency text not null check (currency in ('KRW','JPY')),
  category text not null default '기타',
  type text not null check (type in ('income','expense')),
  created_at timestamptz not null default now()
);

alter table public.transactions enable row level security;

create policy "Users can view their own transactions"
on public.transactions for select
using (auth.uid() = user_id);

create policy "Users can insert their own transactions"
on public.transactions for insert
with check (auth.uid() = user_id);

create policy "Users can delete their own transactions"
on public.transactions for delete
using (auth.uid() = user_id);

create index transactions_user_date_idx
on public.transactions(user_id, date desc, created_at desc);