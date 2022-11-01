--What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id, SUM(menu.price) as total_spent
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id ASC;

--How many days has each customer visited the restaurant?
SELECT sales.customer_id, COUNT (DISTINCT sales.order_date) AS times_visisted
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id ASC;

--What was the first item from the menu purchased by each customer?
SELECT DISTINCT(sales.customer_id), menu.product_name, sales.order_date
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
ORDER BY sales.order_date ASC
LIMIT 3;

--What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT menu.product_name, COUNT(sales.product_id) AS most_purchased
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY menu.product_name;

--Which item was the most popular for each customer?
SELECT DISTINCT(sales.customer_id), menu.product_name, COUNT(sales.product_id) AS most_purchased
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id, menu.product_name
ORDER BY most_purchased DESC
LIMIT 5;

--Which item was purchased first by the customer after they became a member?
SELECT sales.customer_id, menu.product_name
FROM dannys_diner.sales
INNER JOIN dannys_diner.members ON sales.customer_id = members.customer_id
INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
WHERE sales.order_date = '2021-01-11';

--Which item was purchased just before the customer became a member?
SELECT sales.customer_id, menu.product_name, sales.order_date, members.join_date
FROM dannys_diner.sales
INNER JOIN dannys_diner.members ON sales.customer_id = members.customer_id
INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
WHERE sales.order_date <= members.join_date
ORDER BY sales.customer_id;

--What is the total items and amount spent for each member before they became a member?