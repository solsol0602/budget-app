# 한일 가계부

KRW/JPY를 함께 관리하는 개인용 웹 가계부.

## 기능
- 원화(KRW) / 엔화(JPY) 잔액
- 수입 / 지출
- 카테고리와 날짜
- JPY → KRW 자동 환율
- Supabase 기반 기기 간 동기화
- iPhone 홈 화면 설치(PWA)
- PC 브라우저 사용
- JSON 백업

## Supabase 연결
1. 무료 Supabase 프로젝트 생성
2. SQL Editor에서 `transactions` 테이블과 RLS 정책 생성
3. `index.html`의 `SUPABASE_URL`, `SUPABASE_ANON_KEY` 입력
4. GitHub Pages 활성화

프론트엔드에는 Supabase **anon/public key**만 사용하고 service_role key는 절대 넣지 않는다.
