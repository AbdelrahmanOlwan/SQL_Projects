-- Clean sales data
-- Delete markets outside India in market table
DELETE FROM sales.markets WHERE markets_code IN ('Mark097', 'Mark999');

-- Delete rows with wrong data 
SET SQL_SAFE_UPDATES = 0;
DELETE FROM sales.transactions WHERE sales_amount = -1;


-- update sales amont to be all in INR values and currency
update sales.transactions
set sales_amount  = sales_amount * 79.63
where currency = 'USD';

update sales.transactions
set currency  = 'INR';


select distinct currency
from sales.transactions;

-- ------------------------------------------------
-- To Calculate revenue by city we merged transactions table with market table 

select product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency, markets_name
from sales.transactions as t
left join sales.markets as m
on t.market_code = m.markets_code;

-- groping data by markets name to calculate revenue

select markets_name, sales_qty * sales_amount as revenue
from (
select product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency, markets_name
from sales.transactions as t
left join sales.markets as m
on t.market_code = m.markets_code) as RevenueTable
group by markets_name
order by revenue desc;
-- --------------------------------------------------------------
-- Revenue by year and month

select    year, month_name, sum(sales_qty * sales_amount) as revenue
from sales.transactions as t
left join sales.date as d
on t.order_date = d.date
group by year, month_name
order by year
;
-- ------------------------------------------- ->
-- Top five customers by revenue

select custmer_name, sum(sales_qty * sales_amount) as revenue
from sales.transactions  
left join sales.customers 
using(customer_code)
group by custmer_name
order by revenue desc limit 5;

-- ------------------------------------------- ->
-- Top five products by revenue

select product_code, sum(sales_qty * sales_amount) as revenue
from sales.transactions  
group by product_code
order by revenue desc limit 5;

-- Top five products by sales quantaty

select product_code, sum(sales_qty) as QuantitySales 
from sales.transactions  
group by product_code
order by QuantitySales desc limit 5;
-- ------------------------------------------------------>
-- Revnue  & QuantitySales for each product 

select   product_code,QuantitySales,  revenue 
from (
select product_code, sum(sales_qty) as QuantitySales 
from sales.transactions  
group by product_code
) as productQantity

join (
select    product_code,year, sum(sales_qty * sales_amount) as revenue
from sales.transactions as t
left join sales.date as d
on t.order_date = d.date 
group by product_code
) as productRevenue
using(product_code)
group by product_code
;

select    year, month_name, sum(sales_qty * sales_amount) as revenue
from sales.transactions as t
left join sales.date as d
on t.order_date = d.date
group by year, month_name
order by year
;
-- -----------------------------------------------.



