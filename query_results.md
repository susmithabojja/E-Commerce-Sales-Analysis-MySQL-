# Query Results and KPI Snapshot

These results are calculated from the sample data included in `sql/02_sample_data.sql`.
Currency is shown in INR (₹). Run the SQL scripts in MySQL to reproduce and verify the outputs.

## KPI summary

| metric                                      |     value |
|:--------------------------------------------|----------:|
| Customers                                   |      8    |
| Orders                                      |     12    |
| Completed orders                            |      9    |
| Cancelled orders                            |      1    |
| Pending orders                              |      2    |
| Paid revenue (completed orders only)        | 258000    |
| Paid completed orders                       |      9    |
| Average order value (paid completed orders) |  28666.7  |
| Cancellation rate (%)                       |      8.33 |

## Customer count by city

| city      |   customer_count |
|:----------|-----------------:|
| Hyderabad |                3 |
| Bangalore |                2 |
| Chennai   |                1 |
| Mumbai    |                1 |
| Pune      |                1 |

## Gross sales by category

Gross line-item sales include completed orders and are calculated as `quantity × product price`. This is not the same as cash collected.

| category    |   gross_sales |
|:------------|--------------:|
| Electronics |        197000 |
| Furniture   |         48000 |
| Accessories |         13000 |

## Gross sales by product

| product_name   |   gross_sales |
|:---------------|--------------:|
| Laptop         |        120000 |
| Mobile         |         50000 |
| Chair          |         24000 |
| Desk           |         24000 |
| Monitor        |         15000 |
| Headphones     |         12000 |
| Keyboard       |          9000 |
| Mouse          |          4000 |

## Units sold by product (completed orders)

| product_name   |   units_sold |
|:---------------|-------------:|
| Keyboard       |            6 |
| Headphones     |            6 |
| Mouse          |            5 |
| Chair          |            3 |
| Desk           |            2 |
| Laptop         |            2 |
| Mobile         |            2 |
| Monitor        |            1 |

## Monthly paid revenue

| month   |   paid_revenue |
|:--------|---------------:|
| 2025-09 |         258000 |

## Paid spending by customer

|   customer_id |   paid_spending |
|--------------:|----------------:|
|             1 |           80600 |
|             7 |           62000 |
|             2 |           57500 |
|             3 |           20000 |
|             4 |           16800 |
|             5 |           15000 |
|             8 |            6100 |

## Collected amount by payment method

| payment_method   |   collected_amount |
|:-----------------|-------------------:|
| Credit Card      |             173600 |
| UPI              |              47600 |
| Cash             |              36800 |

## Important interpretation notes

- **Paid revenue** means payment rows with `payment_status = 'Paid'` joined to orders with `status = 'Completed'`.
- **Gross line-item sales** means `quantity × products.price` for items in completed orders. It is a separate measure from payment amount.
- The sample data has one payment row per order. A production system may have multiple payment attempts, partial payments, refunds, discounts, taxes, and shipping charges; the model would need to represent those explicitly.
- `orders.status = 'Completed'` does not by itself prove that payment was collected; both order and payment statuses are filtered in paid-revenue queries.
- Customer spending comparisons include customers with at least one qualifying paid completed order. Customers with zero spend are not included in that average.
