use burger;

/*1. How many burgers were ordered?*/
SELECT 
    COUNT(*) AS total_order
FROM
    runner_orders;

/*2.How many unique customer orders were made?*/

SELECT 
    COUNT(DISTINCT (customer_id)) AS distinct_orders
FROM
    customer_orders;

/*3. How many successful orders were delivered by each runner?*/

SELECT 
    COUNT(order_id) AS no_of_order, runner_id
FROM
    runner_orders
WHERE
    cancellation IS NULL
GROUP BY 2;


/*4. How many of each type of burger was delivered?*/


SELECT 
    b.burger_name, COUNT(r.order_id) AS order_count
FROM
    burger_names b
        JOIN
    customer_orders c ON b.burger_id = c.burger_id
        JOIN
    runner_orders r ON c.order_id = r.order_id
        AND r.cancellation IS NULL
GROUP BY 1;


/*5. How many Vegetarian and Meatlovers were ordered by each customer?*/

SELECT 
    COUNT(c.burger_id) AS orders, c.customer_id, b.burger_name
FROM
    customer_orders c
        JOIN
    burger_names b ON c.burger_id = b.burger_id
GROUP BY 3 , 2
ORDER BY 2;



/*6. What was the maximum number of burgers delivered in a single order?*/

SELECT 
    COUNT(c.burger_id) AS max_order, c.order_id
FROM
    customer_orders c
        JOIN
    runner_orders r ON c.order_id = r.order_id
        AND r.cancellation IS NULL
GROUP BY 2
ORDER BY 1 DESC
LIMIT 1;


/*7. For each customer, how many delivered burgers had at least 1 change and how many had no changes?*/

SELECT 
    c.customer_id,
    SUM(CASE
        WHEN c.exclusions <> '  ' OR c.extras <> ' ' THEN 1
        ELSE 0
    END) AS atleast_one_change,
    SUM(CASE
        WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1
        ELSE 0
    END) AS no_change
FROM
    customer_orders c
        JOIN
    runner_orders r ON c.order_id = r.order_id
        AND r.cancellation IS NULL
GROUP BY 1;


/*8. What was the total volume of burgers ordered for each hour of the day?*/

SELECT 
    EXTRACT(HOUR FROM order_time) AS hour,
    COUNT(order_id) AS total_order
FROM
    customer_orders
GROUP BY 1;


/*9. How many runners signed up for each 1 week period?*/

SELECT 
    EXTRACT(WEEK FROM registration_date) AS week,
    COUNT(runner_id)
FROM
    burger_runner
GROUP BY 1;

/*10. What was the average distance travelled for each customer?*/

SELECT 
    c.customer_id,
    SUM(r.distance) / COUNT(c.customer_id) AS avg_distance
FROM
    customer_orders c
        JOIN
    runner_orders r ON c.order_id = r.order_id
        AND r.duration IS NOT NULL
GROUP BY 1; 





