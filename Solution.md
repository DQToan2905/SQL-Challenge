# 1. What is the total amount each customer spent at the restaurant?

```sql
SELECT 
    customer_id,
    SUM(price) AS total_spent
FROM sales AS s
INNER JOIN menu AS m ON s.product_id = m.product_id
GROUP BY customer_id;# 1. What is the total amount each customer spent at the restaurant?
