-- Olist Ecommerce Dataset SQL Analysis


-- Top 10 selling product categories by Revenue


select TOP 10
	p.product_category_name,
	round(sum(oi.price),2) as Total_revenue
FROM
	olist_order_items_dataset oi
join olist_products_dataset p on oi.product_id = p.product_id
GROUP BY
	p.product_category_name
ORDER BY
	Total_revenue DESC

-- Checking Monthly Revenue Trend

SELECT 
  FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS month,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM 
	olist_orders_dataset o
JOIN
	olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY 
	FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
ORDER BY 
	month;


--Averag Delivery Timeby state (days)


select
	c.customer_state,
	round(avg(datediff(day,o.order_purchase_timestamp, o.order_delivered_customer_date)),1) as Avg_Delay_days
from olist_orders_dataset o
join olist_customers_dataset c on o.customer_id= c.customer_id
where
 o.order_status ='Delivered'
group by
	c.customer_state
order by 
Avg_Delay_days desc;

--Top 10 customers by Total Spend

SELECT TOP 10
	c.customer_unique_id,
	round(sum(oi.price),2) as total_spent
FROM
	olist_customers_dataset c
join 
	olist_orders_dataset o on  c.customer_id = o.customer_id
join 
	olist_order_items_dataset oi on o.order_id=oi.order_id
GROUP BY
	c.customer_unique_id
ORDER BY
	total_spent DESC;

-- Average Review score per seller

select
	s.seller_id,
	round(avg(r.review_score *1.0),2) as avg_score
FROM olist_sellers_dataset s
join
	olist_order_items_dataset o on o.seller_id=s.seller_id
join
	olist_order_reviews_dataset r on o.order_id = r.order_id
GROUP BY
	s.seller_id
order by
	avg_score DESC;


-- Repeat Customer percentage


	SELECT 
  ROUND(SUM(CASE WHEN num_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_customer_percentage
FROM (
  SELECT customer_unique_id, COUNT(order_id) AS num_orders
  FROM 
	olist_customers_dataset c
  JOIN 
	olist_orders_dataset o ON c.customer_id = o.customer_id
  GROUP BY 
	customer_unique_id
) t;

-- Number of order by order status

select
	order_status,
	count(*) as total_orders
FROM
	olist_orders_dataset
GROUP BY
	order_status
ORDER BY
	total_orders DESC;


-- Top 5 sellers by numbers of orders fullfilled


select top 5
	s.seller_id,
	count(distinct oi.order_id) as Total_orders
FROM
	olist_sellers_dataset s
join
	olist_order_items_dataset oi  on oi.seller_id=s.seller_id
group by
	s.seller_id
order by
	Total_orders DESC;


-- Average order value by month

select
	format(o.order_purchase_timestamp , 'yyyy-MM') as Month,
	round(sum(oi.price)/count(distinct o.order_id),2) as avg_order_value
from olist_orders_dataset o
join
	olist_order_items_dataset oi on o.order_id=oi.order_id
group by
	format(o.order_purchase_timestamp , 'yyyy-MM')
order by Month;

--  Most frequent delivery durations

SELECT
	datediff(Day,o.order_purchase_timestamp , o.order_delivered_customer_date) as delivery_days,
	count(*) as frequency
	from olist_orders_dataset o
	where o.order_status='delivered'
	group by datediff(Day,o.order_purchase_timestamp , o.order_delivered_customer_date)
	order by frequency desc
	offset 0 rows fetch next 5 rows only;

-- Cancellation Rate

select
	round(count(case when order_status = 'canceled' then 1 end) * 100.0/ count(*),2)as cancellation_rate
from
	olist_orders_dataset


--Top 5 most reviewed products

select
	p.product_category_name,
	count(r.review_id)  as review_count
FROM
	olist_products_dataset p 
join
	olist_order_items_dataset oi on p.product_id=oi.product_id
join 
	olist_order_reviews_dataset r on oi.order_id= r.order_id
group by
 p.product_category_name
 order by
	review_count desc
offset 0 rows  fetch next 5 rows only;

-- Average time between purchase and approval


select
	round(avg(datediff(MINUTE,order_purchase_timestamp,order_approved_at)),2)  as avg_minutes_to_approve
	from
		olist_orders_dataset
	where order_approved_at is not null;

-- state with most revenue

select
	c.customer_state,
	ROUND(sum(oi.price),2) as total_revenue
from
	olist_orders_dataset o
join 
	olist_customers_dataset c on c.customer_id = o.customer_id
join
	olist_order_items_dataset oi on oi.order_id=o.order_id
group by
	c.customer_state
order by
	total_revenue desc;


--percentage or oders late

select
	round(sum(case when		order_delivered_customer_date > order_estimated_delivery_date then 1 else 0 end)* 100.0/count(*),2) as late_order_pecentage
	from 
		olist_orders_dataset
		where order_status='delivered'
		and order_estimated_delivery_date is not null
		and order_estimated_delivery_date is not null;