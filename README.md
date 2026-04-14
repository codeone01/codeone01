# Ucan — Luxury Fictional E‑Commerce Platform

Ucan is a premium, fully responsive fake luxury e-commerce platform with realistic UX flows, built with:
- **Frontend:** HTML, CSS, JavaScript, jQuery, ReactJS
- **Backend:** Java (Spring Boot)
- **Data/Auth/Email verification:** Supabase

## What is included
- Concise implementation plan
- Complete folder structure definition
- Supabase SQL schema + seed data for luxury catalog
- React frontend scaffold with responsive premium UI
- Spring Boot backend scaffold for checkout, orders, admin and email notifications
- Core business rules for fictional balance and one-time email verification bonus
- Catalog search/filter/sort implementation
- Auth/session wiring with Supabase
- Hidden admin dashboard routing and backend guards

## Setup overview
1. Provision Supabase project and SMTP for auth emails.
2. Run `supabase/schema.sql`.
3. Run `supabase/seed.sql`.
4. Configure `frontend/.env` and `backend/src/main/resources/application.yml`.
5. Start frontend and backend.

See docs:
- `docs/IMPLEMENTATION_PLAN.md`
- `docs/FOLDER_STRUCTURE.md`
