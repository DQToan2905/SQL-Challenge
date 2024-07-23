![image](https://github.com/user-attachments/assets/ca20dc99-84b0-4dcf-b7a4-8b1b90404058)
# Introduction

Danny loves Japanese food and opened Danny’s Diner in early 2021, specializing in sushi, curry, and ramen. To improve his restaurant, he needs help analyzing customer data to understand visiting patterns, spending habits, and favorite menu items. This analysis will guide him in possibly expanding the customer loyalty program and generating user-friendly datasets for his team.

# Dataset

Danny has shared with you 3 key datasets for this case study:
### Table 1: sales
The sales table captures all ```customer_id``` level purchases with an corresponding ```order_date``` and ```product_id``` information for when and what menu items were ordered.

![image](https://github.com/user-attachments/assets/c24d082c-6042-4c4f-bd48-78af7ea28449)
### Table 2: menu
The menu table maps the ```product_id``` to the actual ```product_name``` and ```price``` of each menu item.

![image](https://github.com/user-attachments/assets/20d1ff89-2b00-4961-8fdb-796404eb7c1f)
### Table 3: members
The final members table captures the ```join_date``` when a ```customer_id``` joined the beta version of the Danny’s Diner loyalty program.

![image](https://github.com/user-attachments/assets/65ad950d-6837-4c1c-85fb-ffdad385a0d9)

# Entity Relationship Diagram

![1721576761437](https://github.com/user-attachments/assets/1134e0a0-685b-4b1e-99c2-c95e46920245)


# Case Study Questions

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

# Bonus Questions
### 1. Join All The Things
The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL. Recreate the following table output using the available data:

![image](https://github.com/user-attachments/assets/9cbd75d4-8cdd-4d84-a9a3-303b5e193834)

### 2. Rank All The Things
Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

![image](https://github.com/user-attachments/assets/c00f7710-624f-4da6-93f8-689eb4e83ad6)
