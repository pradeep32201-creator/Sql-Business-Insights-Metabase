# Supporting Analytics Tables

These tables support advanced business analysis such as payments, returns, logistics, marketing attribution, customer intelligence, loyalty programs, experiments, and review analytics.

These are not core transactional tables but are essential for deeper business insights.

---

# 1. Payment Analytics

## payment_intents

### Purpose

Tracks payment attempts linked to customer orders.

### Business Use Cases

* Payment success rate
* Payment retries
* Failed payment analysis

### Key Columns

| Column Name       | Description               |
| ----------------- | ------------------------- |
| payment_intent_id | Unique payment attempt ID |
| order_id          | Linked order              |
| created_at        | Payment attempt timestamp |
| payment_method_id | Payment method            |
| amount            | Payment amount            |
| status            | Payment state             |

### Relationships

`payment_intents.order_id → orders.order_id`

---

## payment_transactions

### Purpose

Tracks gateway-level payment transactions.

### Business Use Cases

* Payment gateway failure analysis
* Retry behavior
* Transaction monitoring

### Key Columns

| Column Name       | Description           |
| ----------------- | --------------------- |
| txn_id            | Transaction ID        |
| payment_intent_id | Linked payment intent |
| txn_time          | Transaction timestamp |
| gateway           | Payment gateway       |
| status            | Transaction status    |
| error_code        | Failure reason code   |
| error_message     | Failure message       |

### Relationships

`payment_transactions.payment_intent_id → payment_intents.payment_intent_id`

### Key Insight

Useful for analyzing:

* Failed payments
* Gateway reliability
* Retry patterns

---

# 2. Refund & Return Analytics

## refunds

### Purpose

Tracks refunded orders.

### Business Use Cases

* Refund rate analysis
* Revenue leakage tracking
* Refund trend analysis

### Key Columns

| Column Name | Description       |
| ----------- | ----------------- |
| refund_id   | Refund identifier |
| order_id    | Linked order      |
| created_at  | Refund timestamp  |
| amount      | Refund amount     |
| reason      | Refund reason     |
| status      | Refund status     |

### Relationships

`refunds.order_id → orders.order_id`

---

## return_requests

### Purpose

Stores return requests initiated by customers.

### Business Use Cases

* Product dissatisfaction analysis
* Return behavior tracking

### Key Columns

| Column Name  | Description         |
| ------------ | ------------------- |
| return_id    | Return request ID   |
| order_id     | Linked order        |
| customer_id  | Customer ID         |
| requested_at | Return request time |
| status       | Request status      |

### Relationships

* `return_requests.order_id → orders.order_id`
* `return_requests.customer_id → customers.customer_id`

---

## return_items

### Purpose

Stores item-level details for returns.

### Business Use Cases

* Product return analysis
* Defective product tracking

### Key Columns

| Column Name | Description       |
| ----------- | ----------------- |
| return_id   | Return request ID |
| variant_id  | Returned product  |
| qty         | Quantity returned |
| reason_id   | Return reason     |

### Relationships

* `return_items.return_id → return_requests.return_id`
* `return_items.variant_id → product_variants.variant_id`

### Important Note

A single return request may contain **multiple products/items**.

---

# 3. Fulfillment & Logistics

## shipments

### Purpose

Tracks shipment information for orders.

### Business Use Cases

* Delivery performance
* Shipping SLA tracking
* Order fulfillment analysis

### Key Columns

| Column Name        | Description         |
| ------------------ | ------------------- |
| shipment_id        | Shipment identifier |
| order_id           | Linked order        |
| carrier_id         | Shipping carrier    |
| shipping_method_id | Shipping type       |
| shipped_at         | Shipment date       |
| delivered_at       | Delivery date       |
| tracking_number    | Tracking ID         |
| status             | Shipment status     |

### Relationships

`shipments.order_id → orders.order_id`

---

## shipment_items

### Purpose

Tracks products included in shipments.

### Business Use Cases

* Shipment completeness analysis
* Partial shipment tracking

### Relationships

* `shipment_items.shipment_id → shipments.shipment_id`
* `shipment_items.variant_id → product_variants.variant_id`

---

## tracking_updates

### Purpose

Stores shipment tracking history.

### Business Use Cases

* Delay analysis
* Shipment timeline tracking

### Key Columns

| Column Name | Description        |
| ----------- | ------------------ |
| update_id   | Tracking update ID |
| shipment_id | Shipment reference |
| update_time | Update timestamp   |
| status      | Tracking status    |
| location    | Shipment location  |

### Relationships

`tracking_updates.shipment_id → shipments.shipment_id`

---

# 4. Promotions & Discounts

## coupons

### Purpose

Stores coupon-level discounts.

### Coupon Types

* Percent Discount
* Fixed Discount
* Free Shipping
* BOGO (Buy One Get One)

### Business Use Cases

* Coupon usage analysis
* Discount effectiveness
* Conversion uplift

---

## promotions

### Purpose

Stores promotional campaigns.

### Business Use Cases

* Promotion ROI analysis
* Revenue uplift tracking

---

## promotion_rules

### Purpose

Defines conditions required for promotion eligibility.

### Example Rules

* Minimum cart value
* Product-specific promotion
* Category-specific discount

### Business Use Cases

* Promotion effectiveness
* Discount targeting analysis

---

# 5. Customer Intelligence

## customer_rfm_daily

### Purpose

Precomputed daily customer RFM scores.

### RFM Metrics

* Recency
* Frequency
* Monetary Value

### Business Use Cases

* Cohort analysis
* Customer segmentation
* Churn prediction
* Loyalty analysis

### Key Columns

| Column Name      | Description              |
| ---------------- | ------------------------ |
| recency_days     | Days since last purchase |
| frequency_orders | Number of orders         |
| monetary_value   | Customer spending        |
| rfm_score        | Combined RFM score       |
| rfm_segment      | Customer segment         |

### Important Note

Precomputed snapshot table — useful for faster cohort analysis.

---

# 6. A/B Testing

## experiments

### Purpose

Stores experiment metadata.

### Business Use Cases

* Conversion optimization
* Feature testing

---

## experiment_variants

### Purpose

Stores experiment versions.

### Example

* Variant A
* Variant B

### Business Use Cases

* Variant comparison
* Experiment success analysis

---

## experiment_assignments

### Purpose

Tracks customer/session assignment to experiments.

### Business Use Cases

* A/B test analysis
* Variant performance measurement

### Important Note

Contains **5 historical experiments**.

---

# 7. Review Analytics

## product_reviews

### Purpose

Stores customer reviews and ratings.

### Business Use Cases

* Product satisfaction analysis
* Review sentiment analysis
* Product quality tracking

### Metrics

* Star rating
* Review text
* Review frequency

### Important Note

Contains **~8,000 customer reviews**.

---

# 8. Loyalty Program

## loyalty_accounts

### Purpose

Stores customer loyalty memberships.

### Business Use Cases

* Member tracking
* Tier analysis

---

## loyalty_transactions

### Purpose

Tracks loyalty points earned and redeemed.

### Business Use Cases

* Loyalty engagement
* Redemption behavior

### Important Note

Contains:

* ~3,000 loyalty members
* 4 loyalty tiers

---

# 9. Marketing Attribution

## marketing_campaigns

### Purpose

Stores marketing campaign information.

### Business Use Cases

* Campaign ROI
* Budget analysis

---

## attribution_campaigns

### Purpose

Links attribution touchpoints with marketing campaigns.

### Business Use Cases

* Multi-touch attribution
* Channel contribution analysis

### Warning

Be careful when combining with historical attribution logic to avoid double counting conversions.
