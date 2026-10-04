-- 한일 가계부: 결제수단 + 거래 당시 환율 추가
-- 기존 거래는 payment_method = 'account'로 유지되어 데이터 재입력이 필요하지 않음.

alter table public.transactions
  add column if not exists payment_method text not null default 'account';

alter table public.transactions
  drop constraint if exists transactions_payment_method_check;

alter table public.transactions
  add constraint transactions_payment_method_check
  check (payment_method in ('account','cash'));

alter table public.transactions
  add column if not exists fx_rate_krw_per_jpy numeric;

-- 기존 현금 인출 기록은 ATM에서 계좌에서 뽑은 것이므로 결제수단은 계좌.
update public.transactions
set payment_method='account'
where payment_method is null;

-- 기존 JPY 거래는 과거 실제 환율을 알 수 없으므로 환율을 임의로 덮어쓰지 않음.
-- fx_rate_krw_per_jpy가 비어 있는 기존 거래는 앱이 현재 환율을 사용해 표시하고,
-- 앞으로 저장하는 JPY 거래에는 저장 당시 환율이 기록됨.


-- 계좌 관리 + 계좌 간 이체 지원
-- 기존 거래는 account_id가 비어 있어도 앱이 통화/결제수단 기준으로 기본 계좌를 추정함.

alter table public.transactions
  drop constraint if exists transactions_type_check;

alter table public.transactions
  add constraint transactions_type_check
  check (type in ('income','expense','cash_withdrawal','transfer'));

alter table public.transactions
  add column if not exists account_id text;

alter table public.transactions
  add column if not exists transfer_to_account_id text;

create index if not exists transactions_user_account_date_idx
  on public.transactions(user_id, account_id, date desc);


-- 한국 계좌 ↔ 일본 계좌처럼 통화가 다른 내부 이체 지원
alter table public.transactions
  add column if not exists transfer_to_amount numeric;

alter table public.transactions
  add column if not exists transfer_to_currency text;

alter table public.transactions
  add column if not exists transfer_fx_rate numeric;


-- 거래 수정 지원: 본인 거래만 수정할 수 있도록 UPDATE 권한 추가
drop policy if exists transactions_update_own on public.transactions;

create policy transactions_update_own
on public.transactions
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
