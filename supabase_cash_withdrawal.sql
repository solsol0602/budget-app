-- 한일 가계부: 현금 인출(자산 이동) 기능 추가
-- Supabase SQL Editor에서 이 파일을 한 번 실행해줘.

alter table public.transactions
  drop constraint if exists transactions_type_check;

alter table public.transactions
  add constraint transactions_type_check
  check (type in ('income','expense','cash_withdrawal'));
