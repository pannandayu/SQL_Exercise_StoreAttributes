-- Finding late "Same Day" shipments.
SELECT *
FROM superstore_order
WHERE "Ship Mode" = 'Same Day' and "Order Date" != "Ship Date";

-- Averaging profit and segmenting by discount level.
SELECT AVG("Profit") as "Average Profit",
CASE
	when "Discount" < 0.2 then 'Low'
	when "Discount" > 0.4 then 'High'
	else 'Moderate'
END AS "Discount Level"
FROM superstore_order
GROUP BY "Discount Level"
ORDER BY AVG("Profit") DESC;

-- Finding the average of discount and sales each category and sub-category.
WITH category
AS
(	
	SELECT p."Category", p."Product ID", p."Product Name", p."Sub Category", o."Discount", o."Profit"
	FROM superstore_product as p
	JOIN superstore_order as o
	ON p."Product ID" = o."Product ID"
)
SELECT "Category", "Sub Category", AVG("Discount") as "Average Discount", AVG("Profit") as "Average Profit"
FROM category
GROUP BY "Category", "Sub Category";

-- Finding total sales and average profit on California, Texas, and Georgia states.
SELECT c."Segment", c."State", SUM(o."Sales") as "Total Sales", AVG(o."Profit") as "Average Profit"
FROM superstore_customer as c
JOIN superstore_order as o
ON c."Customer ID" = o."Customer ID"
WHERE c."State" in ('California','Texas','Georgia') and o."Order Date" >= '2016-01-01' and o."Order Date" <= '2016-12-31'
GROUP BY c."Segment", c."State"
ORDER BY c."Segment", c."State";

-- Counting customer with average discount > 0.4 by region.
SELECT customer."Region", count(customer."Region") as "Customer Count"
FROM
(
	SELECT "Customer ID", "Region"
	FROM superstore_customer
) AS customer
JOIN
(
	SELECT "Customer ID", avg("Discount") AS "Average Discount"
	FROM superstore_order
	GROUP BY "Customer ID"
) AS discount
ON customer."Customer ID" = discount."Customer ID"
WHERE discount."Average Discount" > 0.4
GROUP BY customer."Region";