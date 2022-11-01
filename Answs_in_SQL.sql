--What is the total amount each customer spent at the restaurant?
SELECT customer_id, SUM(price) as total_spent
FROM sales
INNER JOIN menu on sales.product_id = menu.product_id
GROUP BY customer_id;

--How many days has each customer visited the restaurant?

WITH superview  AS (
    SELECT DAY(order_date) as days_visited, 
            MONTH(order_date) as month_visited,
            customer_id,
            CONCAT(DAY(order_date), '-', MONTH(order_date)) as day_month
    FROM sales
)

SELECT customer_id, COUNT(DISTINCT(day_month)) as days_visited
FROM superview 
GROUP BY customer_id
GO
  
--What was the first item from the menu purchased by each customer?
SELECT customer_id, order_date, product_name
FROM sales
INNER JOIN menu on sales.product_id = menu.product_id
WHERE order_date = '2021-01-01';

--What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT COUNT(*) as most_purchased, product_name
FROM sales
INNER JOIN menu on sales.product_id = menu.product_id
GROUP BY product_name
ORDER BY most_purchased DESC;

--Which item was the most popular for each customer?
SELECT customer_id, COUNT(*) as most_purchased, product_name
FROM sales
INNER JOIN menu on sales.product_id = menu.product_id
GROUP BY customer_id, product_name
ORDER BY customer_id ASC, most_purchased DESC;

--Which item was purchased first by the customer after they became a member?
WITH answer AS (
    SELECT sales.customer_id,
            order_date, join_date, 
            product_name, 
            RANK() OVER(PARTITION BY sales.customer_id ORDER BY order_date) as rank
    FROM sales
    INNER JOIN menu on sales.product_id = menu.product_id
    INNER JOIN members on members.customer_id = sales.customer_id
    GROUP BY sales.customer_id, order_date, join_date, product_name
    HAVING order_date > join_date 
)

SELECT customer_id, product_name
FROM answer
WHERE rank = 1
GO

--Which item was purchased just before the customer became a member?
WITH answer AS (
    SELECT sales.customer_id,
            order_date, join_date, 
            product_name, 
            RANK() OVER(PARTITION BY sales.customer_id ORDER BY order_date) as rank
    FROM sales
    INNER JOIN menu on sales.product_id = menu.product_id
    INNER JOIN members on members.customer_id = sales.customer_id
    GROUP BY sales.customer_id, order_date, join_date, product_name
    HAVING order_date < join_date 
)

SELECT customer_id, product_name
FROM answer
WHERE (customer_id = 'A' AND rank = 1) OR (customer_id = 'B' AND rank = 3)
GO

--What is the total items and amount spent for each member before they became a member?
WITH answer2 as (
    SELECT sales.customer_id, product_name, price, order_date
    FROM sales
    INNER JOIN menu on sales.product_id = menu.product_id
    INNER JOIN members on members.customer_id = sales.customer_id
    WHERE order_date < join_date
    GROUP BY sales.customer_id, product_name, price, order_date
)

SELECT customer_id, COUNT(product_name) as total_items, SUM(price) as amount_spent
FROM answer2
GROUP BY  customer_id
GO

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
--how many points would each customer have?
WITH answ3 as (
    SELECT sales.customer_id, product_name, price, order_date, price * 10 as points
    FROM sales
    INNER JOIN menu on sales.product_id = menu.product_id
    WHERE product_name = 'curry' or product_name = 'ramen'

    UNION ALL

    SELECT sales.customer_id, product_name, price, order_date, price * 20
    FROM sales
    INNER JOIN menu on sales.product_id = menu.product_id
    WHERE product_name = 'sushi' 
)

SELECT customer_id, SUM(points) as total_points
FROM answ3
GROUP BY customer_id
GO

--In the first week after a customer joins the program (including their join date) 
--they earn 2x points on all items, not just sushi - how many points do customer A and B 
--have at the end of January?