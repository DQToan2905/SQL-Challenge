/* --------------------
   Case Study Questions
   --------------------*/

use [Case study #1 - Danny's Diner]

-- 1. What is the total amount each customer spent at the restaurant?
select 
	customer_id,
	sum(price) as total_spent
from sales as s
inner join menu as m on s.product_id = m.product_id
group by customer_id 

-- 2. How many days has each customer visited the restaurant?
select 
	customer_id,
	count(distinct order_date) as visit_days
from sales 
group by customer_id

-- 3. What was the first item from the menu purchased by each customer?
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

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select top(1)
	M.product_id,
	M.product_name, 
	count(S.order_date) as most_purchased_item
from sales as S 
inner join menu as M on S.product_id = M.product_id
group by M.product_name, m.product_id
order by most_purchased_item desc

-- 5. Which item was the most popular for each customer?
with ranked_item 
as(  
	select 
		S.customer_id,
		M.product_name,
		count(S.order_date) as number_of_purchases,
		rank() over(partition by S.customer_id order by count(S.order_date) desc) as rank
	from sales as S 
	inner join menu as M on S.product_id = M.product_id
	group by s.customer_id, M.product_name
)
select 
	customer_id,
	product_name,
	number_of_purchases
from ranked_item
where rank = 1
order by customer_id 


-- 6. Which item was purchased first by the customer after they became a member?
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

-- 7. Which item was purchased just before the customer became a member?
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

-- 8. What is the total items and amount spent for each member before they became a member?
select 
	s.customer_id,
	count(*) as total_items,
	sum(m.price) as total_spent
from sales as s 
inner join menu as m on s.product_id = m.product_id  
inner join members as me on s.customer_id = me.customer_id 
where s.order_date < me.join_date
group by s.customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
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

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
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


/* ----------------
   Bonus Questions
   ----------------*/

-- Join All The Things
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

-- Rank All The Things
select 
	s.customer_id,
	s.order_date,
	m.product_name,
	m.price,
	case
		when s.order_date < me.join_date then 'N'
		when s.order_date >= me.join_date then 'Y'
		else 'N'
	end as Member,
	case
		when s.order_date >= me.join_date then rank() over (partition by s.customer_id order by s.order_date)
		else Null
	end as Ranking 
from sales as s		
inner join menu as m on s.product_id = m.product_id  
left join members as me on s.customer_id = me.customer_id 
order by s.customer_id asc, s.order_date asc, m.price desc



