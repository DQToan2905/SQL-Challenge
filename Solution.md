# 1. What is the total amount each customer spent at the restaurant?
```sql
select 
	customer_id,
	sum(price) as total_spent
from sales as s
inner join menu as m on s.product_id = m.product_id
group by customer_id 
```
RESULT:

![image](https://github.com/user-attachments/assets/d2b8ce5a-fbf9-4737-bb95-17fa47d4da9a)

# 2. How many days has each customer visited the restaurant?
```sql
select 
	customer_id,
	count(distinct order_date) as visit_days
from sales 
group by customer_id
```
RESULT:

![image](https://github.com/user-attachments/assets/e6c281bb-bb4f-4961-9993-5ff4433f6bc4)

# 3. What was the first item from the menu purchased by each customer?
```SQL
select distinct
	customer_id,
	product_name
from(
	select
		customer_id,
		order_date, 
		product_name,
		RANK() over(partition by customer_id order by order_date asc) as rank
	from sales as s 
	inner join menu as m on s.product_id = m.product_id
) as first_product
where rank = 1
```
RESULT:

![image](https://github.com/user-attachments/assets/1c8a45c7-8a04-49e4-9d71-d3fab4437687)

# 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```SQL
select top(1)
	m.product_id,
	m.product_name, 
	count(s.order_date) as most_purchased_item
from sales as s 
inner join menu as m on s.product_id = m.product_id
group by m.product_name, m.product_id
order by most_purchased_item desc
```
RESULT:

![image](https://github.com/user-attachments/assets/3e4a3df6-fa73-4810-8833-8cf5386e8017)
