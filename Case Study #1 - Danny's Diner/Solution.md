# Case study Questions
## 1. What is the total amount each customer spent at the restaurant?
```sql
select 
	customer_id,
	sum(price) as total_spent
from sales as s
inner join menu as m on s.product_id = m.product_id
group by customer_id 
```
**RESULT:**

![image](https://github.com/user-attachments/assets/d2b8ce5a-fbf9-4737-bb95-17fa47d4da9a)

## 2. How many days has each customer visited the restaurant?
```sql
select 
	customer_id,
	count(distinct order_date) as visit_days
from sales 
group by customer_id
```
**RESULT:**

![image](https://github.com/user-attachments/assets/e6c281bb-bb4f-4961-9993-5ff4433f6bc4)

## 3. What was the first item from the menu purchased by each customer?
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
**RESULT:**

![image](https://github.com/user-attachments/assets/1c8a45c7-8a04-49e4-9d71-d3fab4437687)

## 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
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
**RESULT:**

![image](https://github.com/user-attachments/assets/3e4a3df6-fa73-4810-8833-8cf5386e8017)

## 5. Which item was the most popular for each customer?
```SQL
with ranked_item 
as(  
	select 
		s.customer_id,
		m.product_name,
		count(s.order_date) as number_of_purchases,
		rank() over(partition by s.customer_id order by count(s.order_date) desc) as rank
	from sales as s 
	inner join menu as m on s.product_id = m.product_id
	group by s.customer_id, m.product_name
)
select 
	customer_id,
	product_name,
	number_of_purchases
from ranked_item
where rank = 1
order by customer_id
```
**RESULT:**

![image](https://github.com/user-attachments/assets/f952c87b-4ef5-411b-af34-0b1a22be0078)

## 6. Which item was purchased first by the customer after they became a member?
```SQL
with rank_order_after_join_date 
as(
	select 
		s.customer_id,
		m.product_id,
		m.product_name,
		s.order_date,
		rank() over(partition by s.customer_id order by s.order_date asc) as rank
	from sales as s 
	inner join menu as m on s.product_id = m.product_id  
	inner join members as me on s.customer_id = me.customer_id 
	where s.order_date >= me.join_date 
)
select 
	customer_id,
	product_id,
	product_name, 
	order_date
from rank_order_after_join_date
where rank = 1
```
**RESULT:**

![image](https://github.com/user-attachments/assets/0cb08741-3d6b-4a17-a5db-9a7e791e4b9b)

## 7. Which item was purchased just before the customer became a member?
```SQL
with rank_order_after_join_date 
as(
	select 
		s.customer_id,
		m.product_id,
		m.product_name,
		s.order_date,
		rank() over(partition by s.customer_id order by s.order_date desc) as rank
	from sales as s 
	inner join menu as m on s.product_id = m.product_id  
	inner join members as me on s.customer_id = me.customer_id 
	where s.order_date < me.join_date 
)
select 
	customer_id,
	product_id,
	product_name, 
	order_date
from rank_order_after_join_date
where rank = 1
```
**RESULT:**

![image](https://github.com/user-attachments/assets/d76c6745-82c0-42b9-8095-31d69f26b11a)

## 8. What is the total items and amount spent for each member before they became a member?
```SQL
select 
	s.customer_id,
	count(*) as total_items,
	sum(m.price) as total_spent
from sales as s 
inner join menu as m on s.product_id = m.product_id  
inner join members as me on s.customer_id = me.customer_id 
where s.order_date < me.join_date
group by s.customer_id
```
**RESULT:**

![image](https://github.com/user-attachments/assets/ef33efc8-5e0a-48fe-9fcc-a423df7dbc7e)

## 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
```SQL
select 
	s.customer_id,
	sum(case
		when m.product_name =  'sushi' then m.price*10*2
		else m.price*10
		end
	) as point 
from sales as s 
inner join menu as m on s.product_id = m.product_id 
group by s.customer_id
```
**RESULT:**

![image](https://github.com/user-attachments/assets/9cb0f742-ac95-4cad-9585-979b9a44f390)

## 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```SQL
select 
	s.customer_id,
	sum(case 
			when s.order_date between me.join_date and dateadd(day, 6, me.join_date) then m.price*10*2 
			when m.product_name =  'sushi' then m.price*10*2
			else m.price*10
			end
	) as point
from sales as s		
inner join menu as m on s.product_id = m.product_id  
left join members as me on s.customer_id = me.customer_id 
where s.customer_id in ('A','B') and s.order_date <= '2021-01-31'
group by s.customer_id
```
**RESULT:**

![image](https://github.com/user-attachments/assets/4e1b0dd7-ef36-44e1-a268-584b9403bfc0)

# Bonus Questions
## 1. Join All The Things
```SQL
select 
	s.customer_id,
	s.order_date,
	m.product_name,
	m.price,
	case
		when s.order_date < me.join_date then 'N'`
		when s.order_date >= me.join_date then 'Y'
		else 'N'
		end as member
from sales as s		
inner join menu as m on s.product_id = m.product_id  
left join members as me on s.customer_id = me.customer_id 
order by s.customer_id asc, s.order_date, m.price desc
```
**RESULT:**

![image](https://github.com/user-attachments/assets/08f31452-0b25-4be5-9fdc-e943e2a0dd78)

## 2. Rank All The Things
```SQL
select 
	s.customer_id,
	s.order_date,
	m.product_name,
	m.price,
	case
		when s.order_date < me.join_date then 'N'
		when s.order_date >= me.join_date then 'Y'
		else 'N'
	end as member,
	case
		when s.order_date >= me.join_date then rank() over (partition by s.customer_id order by s.order_date)
		else Null
	end as Ranking 
from sales as s		
inner join menu as m on s.product_id = m.product_id  
left join members as me on s.customer_id = me.customer_id 
order by s.customer_id asc, s.order_date asc, m.price desc
```
**RESULT:**

![image](https://github.com/user-attachments/assets/e1216380-2009-4d6a-a751-9030e3020ed8)



