# 1. What is the total amount each customer spent at the restaurant?
'''sql
select 
	customer_id,
	sum(price) as total_spent
from sales as s
inner join menu as m on s.product_id = m.product_id
group by customer_id 
