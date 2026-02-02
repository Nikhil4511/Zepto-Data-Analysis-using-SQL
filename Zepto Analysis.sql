-- Database: zepto

-- DROP DATABASE IF EXISTS zepto;

CREATE DATABASE zepto
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

create table zeptoo (
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms Integer,
outofStocks Boolean,
quantity integer
);

-- Data Exploration
select count(*) from zeptoo;

-- sample data
select * from zeptoo
limit 10;

-- null values
select * from zeptoo
where name is null
or
category is null
or
mrp is null
or
discountPercent is null
or 
discountedSellingPrice is null
or
weightInGms is null
or
availableQuantity is null
or
outofstocks IS NULL
or
quantity is null;

-- different product categories
select distinct category
from zeptoo
order by category;

-- product in stock vs out of stock
select outofstocks, count(sku_id)
from zeptoo
group by outofstocks;

-- product names present multiple times
select name, count(sku_id) as "Number of SKUs"
from zeptoo
group by  name
Having count(sku_id) > 1
order by count(sku_id) desc;

-- Data Cleaning

-- Product with price = 0
select * from zeptoo
where mrp = 0 or discountedSellingPrice = 0;

delete from zeptoo
where mrp = 0;

-- couvert paise to rupees
update zeptoo
set mrp = mrp/ 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

select mrp, discountedSellingPrice from zeptoo;

select mrp, discountedSellingPrice from zeptoo;

-- Data Analysis

-- Q1. find the top 10 best-value product based on the discount percentage.
select distinct name, mrp, discountpercent
from zeptoo
order by discountpercent desc
limit 10;

-- Q2. What are the Product with High MRP but of stock
select distinct name, mrp
from zeptoo
where outofstocks = True and mrp > 300
order by mrp desc;

-- Q3 Calculate Estimated Revenue for each category
select category, 
sum(discountedSellingPrice * availableQuantity) as total_revenue
from zeptoo
group by category
order by total_revenue;

-- Q4. Find all product where MRP is greater than 500 and discount is less than 10%.
select distinct name, mrp, discountPercent
from zeptoo
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,
round(avg(discountPercent),2) as avg_discount
from zeptoo
group by category
order by avg_discount desc
limit 5;

-- Q6.Find the price per gram for products above 100g and sort by best value.
select distinct name, weightInGms, discountedSellingPrice,
Round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zeptoo
where weightInGms >= 100
Order by price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

-- Q8. What is the Total Inventory Weight per category
select category,
sum(weightInGms * availableQuantity) as total_weight
from zeptoo
group by category
order by total_weight;

-- End of the Project...

