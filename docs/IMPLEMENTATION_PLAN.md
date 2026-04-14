# 1) Concise Implementation Plan

1. **Foundation**
   - Create monorepo with React frontend + Spring Boot backend + Supabase SQL.
   - Establish environment variable strategy and modular architecture.

2. **Data Layer (Supabase/Postgres)**
   - Create normalized tables for users, catalog, cart, checkout, orders, admin and logs.
   - Add RLS and triggers/functions for balance grants and one-time verification bonus.

3. **Authentication & Session**
   - Use Supabase Auth for real signup/login/logout/session.
   - Enable email verification in Supabase and consume callback in frontend.

4. **Catalog Experience**
   - Build premium responsive UI with React + CSS.
   - Add jQuery-enhanced luxury hero interactions.
   - Implement advanced filters, combined queries, sorting and favorites.

5. **Checkout & Payments (Fictional)**
   - Implement cart, address selection, fake card create/reuse and order placement.
   - Deduct fictional balance and persist order + order items.

6. **Transactional Communications**
   - Use Supabase for verification emails.
   - Use backend mail service for purchase confirmation email with test content.

7. **User Area + Hidden Admin**
   - Build user dashboard (profile, balance, orders, cards, addresses, favorites).
   - Build hidden admin route + backend role guards for management endpoints.

8. **Quality and Responsiveness**
   - Ensure desktop/tablet/mobile breakpoints.
   - Validate critical paths in Definition of Done.
