-- SQL_Assignment_2

/* 1. Product Sales
You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (other_product) */

SELECT x.customer_id, x.first_name, x.last_name, 'NO' other_product
FROM sale.customer x
WHERE NOT EXISTS (
        SELECT c.customer_id, c.first_name, c.last_name, p.product_name
        FROM sale.customer c
        INNER JOIN sale.orders o ON c.customer_id=o.customer_id
        INNER JOIN sale.order_item oi ON o.order_id=oi.order_id
        INNER JOIN product.product p ON p.product_id=oi.product_id
        WHERE p.product_name='Polk Audio - 50 W Woofer - Black'
            AND c.customer_id=x.customer_id)
    AND EXISTS (
        SELECT c.customer_id, c.first_name, c.last_name
        FROM sale.customer c
        INNER JOIN sale.orders o ON c.customer_id=o.customer_id
        INNER JOIN sale.order_item oi ON o.order_id=oi.order_id
        INNER JOIN product.product p ON p.product_id=oi.product_id
        WHERE p.product_name='2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
            AND c.customer_id=x.customer_id)
UNION
SELECT x.customer_id, x.first_name, x.last_name, 'YES' other_product
FROM sale.customer x
WHERE EXISTS (
        SELECT c.customer_id, c.first_name, c.last_name
        FROM sale.customer c
        INNER JOIN sale.orders o ON c.customer_id=o.customer_id
        INNER JOIN sale.order_item oi ON o.order_id=oi.order_id
        INNER JOIN product.product p ON p.product_id=oi.product_id
        WHERE p.product_name='Polk Audio - 50 W Woofer - Black'
            AND c.customer_id=x.customer_id)
    AND EXISTS (
        SELECT c.customer_id, c.first_name, c.last_name
        FROM sale.customer c
        INNER JOIN sale.orders o ON c.customer_id=o.customer_id
        INNER JOIN sale.order_item oi ON o.order_id=oi.order_id
        INNER JOIN product.product p ON p.product_id=oi.product_id
        WHERE p.product_name='2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
            AND c.customer_id=x.customer_id)





-- 2. Conversion Rate

-- a. Create above table (Actions) and insert values

CREATE TABLE Actions (
    Visitor_ID int IDENTITY(1,1),
    Adv_Type varchar(255),
    Action varchar(255))
INSERT INTO Actions (Adv_Type, Action)
VALUES ('A', 'Left'),
    ('A', 'Order'),
    ('B', 'Left'),
    ('A', 'Order'),
    ('A', 'Review'),
    ('A', 'Left'),
    ('B', 'Left'),
    ('B', 'Order'),
    ('B', 'Review'),
    ('A', 'Review')

SELECT *
FROM Actions



-- b. Retrieve count of total Actions and Orders for each Advertisement Type

SELECT Adv_Type, Action, COUNT(*) num_of_actions
FROM Actions
GROUP BY Adv_Type, Action
ORDER BY Adv_Type, Action



-- c. Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.

SELECT Adv_Type, CAST(COUNT(Action)*1.0/(SELECT COUNT(*) FROM Actions WHERE Adv_Type='A') AS NUMERIC(18,2)) AS Conversion_Rate
FROM Actions
WHERE Action='Order'
    AND Adv_Type='A'
GROUP BY Adv_Type
UNION
SELECT Adv_Type, CAST(COUNT(Action)*1.0/(SELECT COUNT(*) FROM Actions WHERE Adv_Type='B') AS NUMERIC(18,2)) AS Conversion_Rate
FROM Actions
WHERE Action='Order'
    AND Adv_Type='B'
GROUP BY Adv_Type