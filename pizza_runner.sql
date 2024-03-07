CREATE database pizza_runner;
SET search_path = pizza_runner;
use pizza_runner;
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

use pizza_runner;
DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
 
#----------------------------#
#---------CASE STUDY---------#
#----------------------------# 

 SELECT * FROM customer_orders; 
/*CHANGING THE BLANK SPACES AND "null" to NULL*/ 
SET SQL_SAFE_UPDATEs = 0;
UPDATE customer_orders
SET  extras = NULL
WHERE extras in ("", "null");  
  
UPDATE customer_orders
SET  exclusions = NULL
WHERE exclusions in ("", "null");  
  
SELECT * FROM pizza_runner.runner_orders;  
UPDATE runner_orders
SET  cancellation = NULL
WHERE  cancellation in ("", "null");    
  
UPDATE runner_orders
SET  distance = NULL
WHERE  distance = "null";    
   
UPDATE runner_orders
SET  duration = NULL
WHERE duration  = "null";    
   
UPDATE runner_orders
SET  pickup_time = NULL
WHERE pickup_time  = "null";  
   
UPDATE runner_orders
SET distance = CASE WHEN distance = 'null' THEN NULL 
               WHEN distance LIKE '%km' THEN 
                  TRIM(REPLACE(distance, 'km', '')) ELSE distance END;
            
UPDATE runner_orders
SET duration = CASE WHEN duration LIKE '%min%' THEN 
              SUBSTRING(duration, 1, 2)
               ELSE duration END;

/*Renaming the distance and duration columns to be more descriptive (adding the unit measurements).*/
ALTER TABLE runner_orders
RENAME COLUMN distance TO distance_km;

ALTER TABLE runner_orders
RENAME COLUMN duration TO duration_min;

/*changing the column data types*/
/*ALTER TABLE table_name
MODIFY COLUMN column_name new_data_type;*/
ALTER TABLE runner_orders
MODIFY COLUMN pickup_time Timestamp ;

ALTER TABLE runner_orders
MODIFY COLUMN distance_km float;

ALTER TABLE runner_orders
MODIFY COLUMN duration_min INTEGER; 

/*A. PIZZA METRICS*/
/*How many pizzas were ordered?*/
SELECT COUNT(*) as pizzas_ordred
FROM customer_orders;

/*How many unique customer orders were made?*/
SELECT COUNT(DISTINCT(customer_id)) as unique_customers 
FROM customer_orders;

/*How many successful orders were delivered by each runner?*/
SELECT runner_id, COUNT(order_id) AS successful_orders 
FROM runner_orders
WHERE cancellation IS NULL
GROUP  BY 1;

/*How many of each type of pizza was delivered?*/
SELECT pizza_name, count(pizza_id) as pizzas_delivered
FROM pizza_names INNER JOIN customer_orders USING(pizza_id) 
				 INNER JOIN runner_orders USING(order_id)
WHERE cancellation IS NULL
GROUP BY 1; 

/*How many Vegetarian and Meatlovers were ordered by each customer?*/
SELECT customer_id, pizza_name, COUNT(pizza_id) as pizzas_ordered
FROM pizza_names INNER JOIN customer_orders USING(pizza_id)
                 INNER JOIN runner_orders USING(order_id)
GROUP BY 1,2
ORDER BY 1,2;

/*What was the maximum number of pizzas delivered in a single order?*/

WITH max_pizzas as(SELECT order_id, COUNT(pizza_id) as pizzas_delivered
FROM customer_orders INNER JOIN runner_orders USING(order_id)
WHERE cancellation IS NULL
GROUP BY 1) 
SELECT MAX(pizzas_delivered) as max_pizzas_delivered
FROM max_pizzas;

/*For each customer, how many delivered pizzas had at least 1 change and how many had no changes?*/
SELECT customer_id, SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END) AS no_change, 
					SUM(CASE WHEN (exclusions IS NOT NULL AND extras IS NULL) OR 
						           (exclusions IS NULL AND extras IS NOT NULL) OR
                                   (exclusions IS NOT NULL AND extras IS NOT NULL) THEN 1 ELSE 0 END) AS `change`
FROM customer_orders
WHERE order_id IN (SELECT order_id
                    FROM runner_orders
                    WHERE cancellation IS NULL)
GROUP BY 1;

/*How many pizzas were delivered that had both exclusions and extras?*/
SELECT  SUM(CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END) AS exclsusions_extras_pizzas
FROM customer_orders
WHERE order_id IN (SELECT order_id
                    FROM runner_orders
                    WHERE cancellation IS NULL);

/*What was the total volume of pizzas ordered for each hour of the day?*/

SELECT hour(order_time) AS hours, COUNT(pizza_id) as pizzas_ordered
FROM customer_orders
GROUP BY 1
ORDER BY 1;

/*What was the volume of orders for each day of the week?*/  
SELECT dayname(order_time) as weekdays, COUNT(*) AS  pizzas_ordered
FROM customer_orders
GROUP BY 1
ORDER BY 1;

/*B. Runner and Customer Experience*/
/*How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)*/
SELECT EXTRACT(WEEK FROM registration_date + 3) AS week_of_year,
   COUNT(runner_id) AS resgistrations
FROM runners
GROUP BY 1
ORDER BY 1;


/*What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?*/
SELECT runner_id, round(AVG(TIMESTAMPDIFF(MINUTE, order_time,pickup_time)),2) AS avg_time
FROM runner_orders INNER JOIN customer_orders USING(order_id)
WHERE pickup_time IS NOT NULL
GROUP BY 1;

/*Is there any relationship between the number of pizzas and how long the order takes to prepare?*/
WITH pizzas AS(
    SELECT c.order_id, count(c.order_id) AS PizzaCount, AVG(TIMESTAMPDIFF(MINUTE, order_time, pickup_time)) AS Avgtime
	FROM customer_orders  c INNER JOIN runner_orders r USING(order_id)
	GROUP BY 1
		   )SELECT PizzaCount, ROUND(AVG(Avgtime),2) AS avgtime
            FROM pizzas
            GROUP  BY 1;
            
/*What was the average distance travelled for each customer?*/
SELECT customer_id, ROUND(AVG(distance_km), 2)AS avg_distance
FROM customer_orders INNER JOIN runner_orders USING(order_id)
GROUP BY 1;

/*What was the difference between the longest and shortest delivery times for all orders?*/
SELECT MAX(duration_min)- MIN(duration_min) AS difference
FROM runner_orders
WHERE duration_min IS NOT NULL;

/*What was the average speed for each runner for each delivery and do you notice any trend for these values?*/
SELECT runner_id, order_id,ROUND(distance_km /duration_min,2) AS avg_speed
FROM runner_orders
WHERE distance_km IS NOT NULL AND duration_min IS NOT NULL
ORDER BY 2;

/*What is the successful delivery percentage for each runner?*/
WITH success AS(SELECT runner_id, SUM(CASE WHEN cancellation IS NULL THEN 1 ELSE 0 END) AS successful_delivers,
								  COUNT(*) AS orders
	            FROM runner_orders
                GROUP BY 1)
SELECT runner_id, CONCAT(ROUND((successful_delivers/orders)*100,0), "%") AS delivery_percent
FROM success;

/*C. Ingredient Optimisation*/
Create view recipes as (select pizza_id, trim(j.topping) as topping
from pizza_recipes r join json_table (trim(replace(json_array(r.toppings), ',','","')),
                     '$[*]' columns(topping varchar(50) path '$' )) as j);

select  *
from recipes; 

/*What are the standard ingredients for each pizza?*/
SELECT n.pizza_name, GROUP_CONCAT(p.topping_name) as ingredients 
FROM recipes r
            INNER JOIN pizza_names n using(pizza_id) 
           INNER JOIN pizza_toppings p on p.topping_id= r.topping
group by 1;
/*What was the most commonly added extra?*/

/*NORMALIZATION OF CUSTOMER ORDERS TABLE*/
Create view customer as 
                     (select customer_id, order_id,pizza_id, trim(j.exclusions) as exclusion,
                          trim(k.extras) as extra, order_time
from customer_orders r 
join json_table (trim(replace(json_array(r.exclusions), ',','","')),
                 '$[*]' columns(exclusions varchar(50) path '$' )) as j
  join json_table(trim(replace(json_array(r.extras), ',','","')),
                     '$[*]' columns(extras varchar(50) path '$' )) as k);
select *
from customer;
/*---------------------------------------------------------------------------------------*/
Select topping_name
from customer c inner join pizza_toppings t on c.extra = t.topping_id
where extra is not null
group by 1
order by count(*) desc
limit 1;

/*What was the most common exclusion?*/
Select topping_name
from customer c inner join pizza_toppings t on c.exclusion = t.topping_id
where exclusion is not null
group by 1
order by count(*) desc
limit 1;

/*Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers*/

/*Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders
 table and add a 2x in front of any relevant ingredients. For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"*/



/*What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first? */

/*D. Pricing and Ratings*/
/*If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much 
money has Pizza Runner made so far if there are no delivery fees?*/
SELECT sum(case when pizza_id = 1 then 12 else 10 end) as revenue
FROM customer_orders inner join runner_orders using(order_id)
WHERE cancellation is null;

/*What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra*/
WITH charges AS (
				SELECT SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) AS pizza_charges,
					   SUM(CASE WHEN extras IS NOT NULL THEN
							(CASE WHEN length(extras)=1 THEN 1 ELSE LENGTH(REPLACE(extras, ", ", ''))END)END) AS extra_charges
                FROM customer_orders INNER JOIN runner_orders USING(order_id)
                WHERE cancellation IS NULL
				) SELECT (pizza_charges+extra_charges) AS total_charges
				  FROM charges;
                            
/*The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
how would you design an additional table for this new dataset - generate a schema for this new table and insert 
your own data for ratings for each successful customer order between 1 to 5.
Using your newly generated table - can you join all of the information together to form a table 
which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas*/ 
#---- FLOOR(RAND() * (<max> - <min> + 1)) + <min>-----#
#----CREATES ANY RANDOM NUMBER BETWEEN MIN AND MAX----#
drop table if exists ratings ;

CREATE temporary table ratings
SELECT runner_id, order_id,FLOOR(RAND() * (5 - 1 + 1)) + 1 as rating
FROM runner_orders;

select * from ratings;


/*If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each 
runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?*/
WITH costs AS (
			SELECT sum(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) AS pizza, 
                                                  (SELECT SUM(distance_km*0.30)
												   FROM runner_orders
												   WHERE distance_km IS NOT NULL) AS runner_paid
            FROM customer_orders INNER JOIN runner_orders USING(order_id)
            WHERE cancellation IS NULL
            )
SELECT ROUND((pizza- runner_paid),2) AS left_over_money
FROM costs;





