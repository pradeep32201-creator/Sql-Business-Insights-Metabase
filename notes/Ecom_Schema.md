## orders

### Purpose
Stores customer order transactions.

### Primary Key
`order_id`

### Foreign Key
`customer_id → customers.customer_id`

### Columns

| Column Name | Data Type | is_nullable |
|-------------|------------|-------------|
| order_id | bigint | NO
| order_number | text |NO
| created_at | timestamp with time zone | NO
| ustomer_id | bigint |YES
| session_id | uuid | YES
| cart_id | uuid | YES
| price_list_id | bigint | YES
| status | text | NO
| subtotal | numeric | NO
| discount | numeric | NO
| tax | numeric | NO
| shipping_fee | numeric | NO
| total | numeric | NO
| payment_status| text | NO
| shipping_address_id | bigint |YES
| billing_address_id | bigint | YES
| applied_coupon_id | bigint | YES
| applied_promo_id | bigint | YES

## addresses

### Purpose
Stores customer address.

### Primary Key
`address_id`

### Foreign Key
`customer_id → customers.customer_id`

### Columns

| Column Name | Data Type | is_nullable |
|-------------|------------|-------------|
| address_id|bigint | NO
|line1 | text |YES
|line2 | text|YES
|landmark | text|YES
|city| text|YES
|state | text| YES
|country | text | YES
|postal_code | text | YES
|latitude | numeric | YES
|longitude | numeric | YES


### Business Meaning
Used to analyze revenue, retention, and customer behavior.