# 2) Folder Structure

```text
/workspace/codeone01
├── README.md
├── docs/
│   ├── IMPLEMENTATION_PLAN.md
│   └── FOLDER_STRUCTURE.md
├── supabase/
│   ├── schema.sql
│   └── seed.sql
├── frontend/
│   ├── package.json
│   ├── index.html
│   ├── vite.config.js
│   ├── .env.example
│   └── src/
│       ├── main.jsx
│       ├── App.jsx
│       ├── styles/
│       │   └── app.css
│       ├── services/
│       │   ├── supabaseClient.js
│       │   ├── catalogService.js
│       │   └── checkoutService.js
│       ├── context/
│       │   ├── AuthContext.jsx
│       │   └── CartContext.jsx
│       ├── components/
│       │   ├── Header.jsx
│       │   ├── ProductCard.jsx
│       │   ├── FiltersPanel.jsx
│       │   └── HiddenAdminGate.jsx
│       └── pages/
│           ├── HomePage.jsx
│           ├── CatalogPage.jsx
│           ├── LoginPage.jsx
│           ├── SignupPage.jsx
│           ├── DashboardPage.jsx
│           ├── CheckoutPage.jsx
│           └── HiddenAdminPage.jsx
└── backend/
    ├── pom.xml
    └── src/main/
        ├── java/com/ucan/
        │   ├── UcanApplication.java
        │   ├── config/
        │   │   ├── CorsConfig.java
        │   │   └── MailConfig.java
        │   ├── security/
        │   │   ├── JwtFilter.java
        │   │   └── SecurityConfig.java
        │   ├── controller/
        │   │   ├── CatalogController.java
        │   │   ├── CheckoutController.java
        │   │   └── AdminController.java
        │   ├── service/
        │   │   ├── CatalogService.java
        │   │   ├── CheckoutService.java
        │   │   └── EmailService.java
        │   ├── repository/
        │   │   ├── CatalogRepository.java
        │   │   └── CheckoutRepository.java
        │   └── dto/
        │       ├── CheckoutRequest.java
        │       └── FakeCardRequest.java
        └── resources/
            └── application.yml
```
