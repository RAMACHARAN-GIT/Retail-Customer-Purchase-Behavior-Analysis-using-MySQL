use one;
show tables;
DESCRIBE customer_details;
DESCRIBE basket_details;
select * from customer_details limit 5;
select * from basket_details limit 5;

select count(*) as total_records from customer_details;
select count(*) as total_records from basket_details;

select * from customer_details where customer_id is null;
select * from basket_details where customer_id is null;

select count(*) as number_of_duplicate_records from customer_details group by customer_id having count(*) > 1;
select customer_id, count(*) as total_duplicated_records from basket_details group by customer_id having count(*) > 1;


create table basket_detail as
select distinct customer_id, product_id, basket_date, basket_count from basket_details;

Describe basket_detail;
select count(*) as total_records from basket_detail;
select count(*) as total_records from basket_detail having count(*) > 1;

drop table basket_details;

select count(*) as total_nulls from customer_details where customer_id is null or sex is null or customer_age is null or tenure is null;
select count(*) as total_nulls from basket_detail where customer_id is null or product_id
is null or basket_date is null or basket_count is null;

select * from customer_details;
select * from basket_detail;

-- Top 10 customers by total purchase
select customer_id as Top_Customers, sum(basket_count) as total_purchase  from basket_detail group by customer_id order by sum(basket_count) desc limit 10;

-- Average basket size per customer
select customer_id,avg(basket_count) as average_purchase from basket_detail group by customer_id order by avg(basket_count) desc limit 10;

-- Most popular five Products
select product_id, sum(basket_count) as total_purchase from basket_detail group by product_id order by total_purchase desc limit 5;

-- Customer Segmentation by Age group
select 
case
when customer_age < 25 Then 'under 25'
when customer_age between 25 and 40 Then '25-40'
when customer_age between 41 and 60 Then '41-60'
else '61+'
end as age_group,
count(distinct a.customer_id) as total_customers,
sum(b.basket_count) as total_purchase
from customer_details as a join basket_detail as b on a.customer_id = b.customer_id
group by age_group order by total_purchase desc;

-- Gender wise purchase Analysis
SELECT 
    c.sex,
    COUNT(DISTINCT b.customer_id) AS total_customers,
    SUM(b.basket_count) AS total_items_purchased,
    AVG(b.basket_count) AS avg_items_per_transaction
FROM basket_detail b
JOIN customer_details c
ON b.customer_id = c.customer_id
GROUP BY c.sex;

-- Customer with highest product diversity
select customer_id, count(distinct product_id) as total_products from basket_detail group by customer_id order by total_products desc limit 5;

-- Monthly Sales Trend
select
date_format(basket_date, '%y-%m') as month,
sum(basket_count) as total_purchase
from basket_detail
group by month
order by month asc;

-- High Tenure Customers Spending Analysis
-- long term customer spend more 

SELECT a.customer_id,
       COUNT(b.basket_count) AS total_purchase,
       a.tenure AS total_tenure
FROM basket_detail b
JOIN customer_details a 
     ON a.customer_id = b.customer_id
GROUP BY a.customer_id, a.tenure
ORDER BY a.tenure DESC
LIMIT 5;

-- Repeat Purchase Customers
SELECT 
customer_id,
COUNT(*) AS total_transactions
FROM basket_detail
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_transactions DESC;


