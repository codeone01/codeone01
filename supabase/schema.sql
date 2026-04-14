-- 3) Database schema (Supabase/PostgreSQL)
create extension if not exists "pgcrypto";

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique not null,
  full_name text,
  avatar_url text,
  is_email_verified boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists user_roles (
  id bigserial primary key,
  user_id uuid not null references profiles(id) on delete cascade,
  role text not null check (role in ('user', 'admin')),
  unique (user_id, role)
);

create table if not exists user_balances (
  user_id uuid primary key references profiles(id) on delete cascade,
  balance numeric(18,2) not null default 0,
  updated_at timestamptz default now()
);

create table if not exists email_bonus_logs (
  id bigserial primary key,
  user_id uuid not null references profiles(id) on delete cascade,
  bonus_amount numeric(18,2) not null,
  reason text not null,
  granted_at timestamptz default now(),
  unique (user_id, reason)
);

create table if not exists categories (
  id bigserial primary key,
  name text unique not null,
  slug text unique not null
);

create table if not exists subcategories (
  id bigserial primary key,
  category_id bigint not null references categories(id) on delete cascade,
  name text not null,
  slug text not null,
  unique (category_id, slug)
);

create table if not exists brands (
  id bigserial primary key,
  name text unique not null
);

create table if not exists product_types (
  id bigserial primary key,
  name text unique not null
);

create table if not exists colors (
  id bigserial primary key,
  name text unique not null,
  hex_code text
);

create table if not exists products (
  id bigserial primary key,
  name text not null,
  category_id bigint not null references categories(id),
  subcategory_id bigint not null references subcategories(id),
  brand_id bigint not null references brands(id),
  product_type_id bigint not null references product_types(id),
  color_id bigint not null references colors(id),
  price numeric(18,2) not null,
  short_description text,
  long_description text,
  specifications jsonb default '{}'::jsonb,
  stock integer default 0,
  premium_badge boolean default false,
  featured boolean default false,
  fictional_delivery_time text,
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists product_images (
  id bigserial primary key,
  product_id bigint not null references products(id) on delete cascade,
  image_url text not null,
  sort_order integer default 0
);

create table if not exists product_videos (
  id bigserial primary key,
  product_id bigint not null references products(id) on delete cascade,
  video_url text not null,
  sort_order integer default 0
);

create table if not exists carts (
  id bigserial primary key,
  user_id uuid not null unique references profiles(id) on delete cascade,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists cart_items (
  id bigserial primary key,
  cart_id bigint not null references carts(id) on delete cascade,
  product_id bigint not null references products(id),
  quantity integer not null check (quantity > 0),
  unique (cart_id, product_id)
);

create table if not exists fake_cards (
  id bigserial primary key,
  user_id uuid not null references profiles(id) on delete cascade,
  printed_name text not null,
  card_number_masked text not null,
  card_number_last4 text not null,
  expiration text not null,
  cvv_hash text not null,
  nickname text,
  brand text,
  created_at timestamptz default now()
);

create table if not exists saved_addresses (
  id bigserial primary key,
  user_id uuid not null references profiles(id) on delete cascade,
  label text,
  recipient_name text not null,
  street text not null,
  number text not null,
  city text not null,
  state text not null,
  postal_code text not null,
  country text not null default 'Brazil',
  created_at timestamptz default now()
);

create table if not exists orders (
  id bigserial primary key,
  user_id uuid not null references profiles(id),
  total_amount numeric(18,2) not null,
  status text not null default 'created',
  payment_method text not null,
  fake_card_id bigint references fake_cards(id),
  delivery_eta text,
  created_at timestamptz default now()
);

create table if not exists order_items (
  id bigserial primary key,
  order_id bigint not null references orders(id) on delete cascade,
  product_id bigint not null references products(id),
  product_name_snapshot text not null,
  unit_price numeric(18,2) not null,
  quantity integer not null,
  subtotal numeric(18,2) not null
);

create table if not exists order_addresses (
  id bigserial primary key,
  order_id bigint not null unique references orders(id) on delete cascade,
  recipient_name text not null,
  street text not null,
  number text not null,
  city text not null,
  state text not null,
  postal_code text not null,
  country text not null
);

create table if not exists order_status_history (
  id bigserial primary key,
  order_id bigint not null references orders(id) on delete cascade,
  status text not null,
  changed_at timestamptz default now()
);

create table if not exists favorites (
  user_id uuid not null references profiles(id) on delete cascade,
  product_id bigint not null references products(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, product_id)
);

create table if not exists reviews (
  id bigserial primary key,
  user_id uuid not null references profiles(id),
  product_id bigint not null references products(id),
  rating integer not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz default now()
);

create table if not exists banners (
  id bigserial primary key,
  title text not null,
  subtitle text,
  image_url text,
  cta_label text,
  cta_link text,
  active boolean default true
);

create table if not exists featured_sections (
  id bigserial primary key,
  title text not null,
  description text,
  position integer default 0,
  active boolean default true
);

create table if not exists notifications (
  id bigserial primary key,
  user_id uuid not null references profiles(id),
  title text not null,
  message text not null,
  read boolean default false,
  created_at timestamptz default now()
);

create table if not exists admin_logs (
  id bigserial primary key,
  admin_user_id uuid not null references profiles(id),
  action text not null,
  metadata jsonb,
  created_at timestamptz default now()
);

-- Core business rules
create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into public.profiles (id, email, is_email_verified)
  values (new.id, new.email, coalesce(new.email_confirmed_at is not null, false));

  insert into public.user_roles(user_id, role) values (new.id, 'user');

  insert into public.user_balances(user_id, balance) values (new.id, 100000.00);

  insert into public.email_bonus_logs(user_id, bonus_amount, reason)
  values (new.id, 100000.00, 'signup_grant')
  on conflict do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_auth_user();

create or replace function public.handle_email_verification_bonus()
returns trigger
language plpgsql
security definer
as $$
begin
  if new.email_confirmed_at is not null and old.email_confirmed_at is null then
    update profiles set is_email_verified = true, updated_at = now() where id = new.id;

    if not exists (
      select 1 from email_bonus_logs
      where user_id = new.id and reason = 'email_verification_bonus'
    ) then
      update user_balances
      set balance = balance + 100000000.00,
          updated_at = now()
      where user_id = new.id;

      insert into email_bonus_logs(user_id, bonus_amount, reason)
      values (new.id, 100000000.00, 'email_verification_bonus');
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists on_auth_user_verified on auth.users;
create trigger on_auth_user_verified
after update of email_confirmed_at on auth.users
for each row execute function public.handle_email_verification_bonus();

-- Helpful view for advanced product listing
create or replace view v_catalog_products as
select
  p.id,
  p.name,
  c.name as category,
  sc.name as subcategory,
  b.name as brand,
  pt.name as type,
  co.name as color,
  p.price,
  p.short_description,
  p.long_description,
  p.specifications,
  p.stock,
  p.premium_badge,
  p.featured,
  p.fictional_delivery_time,
  (
    select image_url from product_images pi where pi.product_id = p.id order by sort_order asc limit 1
  ) as primary_image
from products p
join categories c on c.id = p.category_id
join subcategories sc on sc.id = p.subcategory_id
join brands b on b.id = p.brand_id
join product_types pt on pt.id = p.product_type_id
join colors co on co.id = p.color_id
where p.active = true;
