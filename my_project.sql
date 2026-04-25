CREATE DATABASE IF NOT EXISTS munu
USE munu

SHOW TABLES	

SELECT * FROM customer_details

SELECT gender,SUM(purchase_amount) AS Revenue
FROM customer_details
GROUP BY gender

SELECT customer_id,purchase_amount
FROM customer_details
WHERE discount_applied="Yes" AND purchase_amount>=(SELECT AVG(purchase_amount) FROM customer_details)

SELECT item_purchased,ROUND(AVG(review_rating),2) AS review_avg
FROM customer_details
GROUP BY item_purchased
ORDER BY review_avg DESC
LIMIT 5

SELECT shipping_type,ROUND(AVG(purchase_amount),2) AS AVG_Purchase
FROM customer_details
WHERE shipping_type in ('Standard','express')
GROUP BY shipping_type

SELECT subscription_status AS Subscribed_or_not,
COUNT(*) AS Total_customer,
ROUND(AVG(purchase_amount),2) AS AVG_purchase,
ROUND(SUM(purchase_amount),2) AS Total_revenue
FROM customer_details
GROUP BY Subscribed_or_not
ORDER BY Total_revenue , AVG_purchase DESC

SELECT item_purchased,
ROUND(100*sum(CASE WHEN discount_applied="Yes" THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM customer_details
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5

WITH customer_type AS(
	Select customer_id,previous_purchases,
    CASE
		WHEN previous_purchases=1 THEN "New"
        WHEN previous_purchases BETWEEN 2 AND 10 THEN "Returning"
        ELSE "Loyal"
		END AS customer_segment
	FROM customer_details
)

SELECT customer_segment, COUNT(*) AS Total_Customer
FROM customer_type
GROUP BY customer_segment

WITH item_counts AS(
	SELECT category,item_purchased,
    COUNT(customer_id) AS total_orders,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer_details
    GROUP BY category,item_purchased
) 
SELECT item_rank,category,item_purchased,total_orders
FROM item_counts
WHERE item_rank<=3;

SELECT subscription_status,COUNT(customer_id) AS Repeat_Buyers
FROM customer_details
WHERE previous_purchases>5 
GROUP BY subscription_status

SELECT age_group,SUM(purchase_amount) AS Revenue_Per_Group
FROM customer_details
GROUP BY age_group
ORDER BY Revenue_Per_Group DESC