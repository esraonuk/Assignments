-- SQL_Assignment_3

/*
Discount Effects

Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.

In this assignment, you are expected to generate a solution using SQL with a logical approach.
*/


--** Find the total amount of products for each product_id and discount pair
SELECT DISTINCT product_id, discount, SUM(quantity) OVER(PARTITION BY product_id, discount) total_quantity
    FROM sale.order_item;

-----------------------------------------------

--** Calculate the variables to be used in the regression analysis
WITH t1 AS (
    SELECT DISTINCT product_id, discount, SUM(quantity) OVER(PARTITION BY product_id, discount) total_quantity
    FROM sale.order_item
)
SELECT *, 
    AVG(discount) OVER(PARTITION BY product_id) x_mean,
    AVG(total_quantity) OVER(PARTITION BY product_id) y_mean,
    SUM(discount * total_quantity) OVER(PARTITION BY product_id) total_xy,
    SUM(discount * discount) OVER(PARTITION BY product_id) total_x_square,
    COUNT(*) OVER(PARTITION BY product_id) n
FROM t1;

-----------------------------------------------

--** Place the above values ​​into the regression analysis formula
--** Add 0.0001 to the denominator to get rid of values ​​that make the denominator zero
WITH t1 AS (
    SELECT DISTINCT product_id, discount, SUM(quantity) OVER(PARTITION BY product_id, discount) total_quantity
    FROM sale.order_item
), t2 AS (
    SELECT *, 
        AVG(discount) OVER(PARTITION BY product_id) x_mean,
        AVG(total_quantity) OVER(PARTITION BY product_id) y_mean,
        SUM(discount * total_quantity) OVER(PARTITION BY product_id) total_xy,
        SUM(discount * discount) OVER(PARTITION BY product_id) total_x_square,
        COUNT(*) OVER(PARTITION BY product_id) n
    FROM t1
)
SELECT *, CAST((total_xy - n * x_mean * y_mean)*1.0 / (total_x_square - n * x_mean * x_mean + 0.0001) AS NUMERIC(5,2)) AS b 
FROM t2;


-----------------------------------------------

--** Classify the obtained results as positive, negative and neutral and obtaine the desired output
WITH t1 AS (
    SELECT DISTINCT product_id, discount, SUM(quantity) OVER(PARTITION BY product_id, discount) total_quantity
    FROM sale.order_item
), t2 AS (
    SELECT *, 
        AVG(discount) OVER(PARTITION BY product_id) x_mean,
        AVG(total_quantity) OVER(PARTITION BY product_id) y_mean,
        SUM(discount * total_quantity) OVER(PARTITION BY product_id) total_xy,
        SUM(discount * discount) OVER(PARTITION BY product_id) total_x_square,
        COUNT(*) OVER(PARTITION BY product_id) n
    FROM t1
), t3 AS (
    SELECT *, CAST((total_xy - n * x_mean * y_mean)*1.0 / (total_x_square - n * x_mean * x_mean + 0.0001) AS NUMERIC(5,2)) AS b 
    FROM t2
)
SELECT DISTINCT product_id,
    CASE 
        WHEN b >= 0.5 THEN 'Positive'
        WHEN b <= -0.5 THEN 'Negative'
        ELSE 'Neutral'
    END 'Discount Effect'
FROM t3
ORDER BY product_id;

-----------------------------------------------