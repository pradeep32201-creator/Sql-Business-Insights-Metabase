# Primary Database Schema Documentation

## Overview

This ecommerce database is designed to track customer behavior, transactions, product purchases, and marketing attribution.

**Core flow:** `Customer → Session → Touchpoint → Order → Order Item → Product`

---

# 1. customers

> Use for: acquisition analysis, segmentation, cohort analysis, retention

**PK:** `customer_id`

| Column Name         | Data Type   | Description                |
| ------------------- | ----------- | -------------------------- |
| customer_id         | bigint      | Unique customer identifier |
| created_at          | timestamptz | Customer signup timestamp  |
| first_name          | text        | Customer first name        |
| last_name           | text        | Customer last name         |
| dob                 | date        | Date of birth              |
| gender              | text        | Customer gender            |
| primary_email       | text        | Email address              |
| primary_phone       | text        | Phone number               |
| country             | text        | Country                    |
| state               | text        | State                      |
| city                | text        | City                       |
| marketing_opt_in    | boolean     | Marketing consent          |
| lifecycle_stage     | text        | Customer stage             |
| acquisition_channel | text        | Source of acquisition      |
| utm_source          | text        | Marketing source           |
| utm_medium          | text        | Marketing medium           |
| utm_campaign        | text        | Marketing campaign         |

**Relationships**
- `customers.customer_id → orders.customer_id`
- `customers.customer_id → sessions.customer_id`

---

# 2. sessions

> Use for: traffic analysis, funnel analysis, session-to-order conversion

**PK:** `session_id`

| Column Name  | Data Type   | Description               |
| ------------ | ----------- | ------------------------- |
| session_id   | uuid        | Unique session identifier |
| started_at   | timestamptz | Session start time        |
| ended_at     | timestamptz | Session end time          |
| customer_id  | bigint      | Linked customer           |
| anonymous_id | uuid        | Anonymous visitor ID      |
| device_id    | bigint      | Device reference          |
| country      | text        | Visitor country           |
| region       | text        | Visitor region            |
| city         | text        | Visitor city              |
| landing_page | text        | First visited page        |
| referrer     | text        | Traffic source            |

**Relationships**
- `sessions.customer_id → customers.customer_id`
- `sessions.session_id → orders.session_id`
- `sessions.session_id → attribution_touches.session_id`

---

# 3. attribution_touches

> Use for: marketing attribution, CAC analysis, campaign ROI, channel performance

**PK:** `touch_id`

| Column Name  | Data Type   | Description          |
| ------------ | ----------- | -------------------- |
| touch_id     | bigint      | Unique touchpoint ID |
| session_id   | uuid        | Session reference    |
| touched_at   | timestamptz | Touchpoint timestamp |
| utm_source   | text        | Traffic source       |
| utm_medium   | text        | Marketing medium     |
| utm_campaign | text        | Campaign name        |
| utm_term     | text        | Paid keyword         |
| utm_content  | text        | Ad content           |
| channel      | text        | Marketing channel    |
| referrer     | text        | Referring source     |

**Relationships**
- `attribution_touches.session_id → sessions.session_id`

---

# 4. orders

> Use for: revenue analysis, AOV calculation, purchase behavior, retention

**PK:** `order_id`

| Column Name    | Data Type   | Description           |
| -------------- | ----------- | --------------------- |
| order_id       | bigint      | Unique order ID       |
| order_number   | text        | Business order number |
| created_at     | timestamptz | Order timestamp       |
| customer_id    | bigint      | Purchasing customer   |
| session_id     | uuid        | Session reference     |
| status         | text        | Order status          |
| subtotal       | numeric     | Product subtotal      |
| discount       | numeric     | Discount amount       |
| tax            | numeric     | Tax charged           |
| shipping_fee   | numeric     | Shipping cost         |
| total          | numeric     | Final order value     |
| payment_status | text        | Payment status        |

**Relationships**
- `orders.customer_id → customers.customer_id`
- `orders.order_id → order_items.order_id`
- `orders.session_id → sessions.session_id`

---

# 5. order_items

> Use for: product sales analysis, basket analysis, revenue contribution

**Composite PK:** `order_id + variant_id`

| Column Name   | Data Type | Description        |
| ------------- | --------- | ------------------ |
| order_id      | bigint    | Order reference    |
| variant_id    | bigint    | Product variant    |
| qty           | integer   | Quantity purchased |
| unit_price    | numeric   | Price per unit     |
| line_discount | numeric   | Discount amount    |
| line_total    | numeric   | Final line amount  |

**Relationships**
- `order_items.order_id → orders.order_id`
- `order_items.variant_id → product_variants.variant_id`

---

# 6. products

> Use for: product performance, category analysis, revenue contribution

**PK:** `product_id`

| Column Name  | Data Type   | Description           |
| ------------ | ----------- | --------------------- |
| product_id   | bigint      | Unique product ID     |
| created_at   | timestamptz | Product creation date |
| product_name | text        | Product name          |
| brand_id     | bigint      | Brand reference       |
| category_id  | bigint      | Category reference    |
| description  | text        | Product description   |
| is_active    | boolean     | Active status         |

**Relationships**
- `products.product_id → product_variants.product_id`

---

# 7. product_variants

> Use for: SKU analysis, size/color demand, inventory analysis

**PK:** `variant_id`

| Column Name | Data Type | Description           |
| ----------- | --------- | --------------------- |
| variant_id  | bigint    | Variant identifier    |
| product_id  | bigint    | Parent product        |
| sku         | text      | Stock keeping unit    |
| color       | text      | Product color         |
| size        | text      | Product size          |
| attributes  | jsonb     | Variant attributes    |
| is_active   | boolean   | Variant active status |

**Relationships**
- `product_variants.product_id → products.product_id`
- `product_variants.variant_id → order_items.variant_id`

---

# 8. session_events

> Use for: funnel analysis, drop-off analysis, conversion optimization

**PK:** `event_id`

**Example Events:** Page View · Add to Cart · Product Click · Checkout Started · Purchase Completed

**Relationships**
- `session_events.session_id → sessions.session_id`

---

# Entity Relationship Summary

```
customers → sessions → attribution_touches
         ↓
       orders → order_items → product_variants → products
```

---


