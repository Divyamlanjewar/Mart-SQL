select * from weekly_sales limit 10;

-------------------cleaning----------------------------
----------------------------------------------------------
CREATE TABLE clean_weekly_sales AS
SELECT week_date,
       WEEK(week_date) AS week_number,
       MONTH(week_date) AS month_number,
       YEAR(week_date) AS calendar_year,
       region,
       platform,
       CASE WHEN segment IS NULL THEN 'unknown'
            ELSE segment
       END AS segment,
       CASE WHEN RIGHT(segment, 1) = '1' THEN 'young Adult'
            WHEN RIGHT(segment, 1) = '2' THEN 'middle Aged'
            WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'retirees'
            ELSE 'unknown'
       END AS age_band,
       CASE WHEN LEFT(segment, 1) = 'c' THEN 'couple'
            WHEN LEFT(segment, 1) = 'f' THEN 'families'
            ELSE 'unknown'
       END AS demographic,
       customer_type,
       transactions,
       sales,
       ROUND(sales / transactions, 2) AS 'avg_transaction'
FROM weekly_sales;
---------------------------------
select * from clean_weekly_sales
---------------------------------

create table seq100(x int auto_increment primary key);
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
-----------
select * from seq100;
-----------
insert into seq100 select x+50 from seq100;
-----------
create table seq52 as (select x from seq100 limit 52);
select * from seq52
-------------
select distinct x as week_day from seq52
where x not in (select distinct week_number from clean_weekly_sales);

-------------Q1>>>>week no that are not present in clean weekly sales<<<<<---------------
select distinct week_number from clean_weekly_sales;

-------------Q2>>>>how manay total transction were there for eaqch year in data set<<<<<---------------
select calendar_year,
sum(transactions) as total_transactions
from clean_weekly_sales group by calendar_year;
-----------------------------------------------

-------------Q3>>>>what are total sales for each region and each month<<<<<---------------
SELECT region, month_number, SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY month_number, region;
-----------------------------------------------

-------------Q4>>>>what are total count of transactiona for each platform<<<<<---------------
select platform,
sum(transactions) as total_transactions from clean_weekly_sales
group by platform;
------------------------------------------------

-------------Q5>>>>what is percentage of sales for retail and shopify for each month<<<<<---------------
WITH cte_monthly_platform_sales AS (
    SELECT
        month_number,
        calendar_year,
        platform,
        SUM(sales) AS monthly_sales
    FROM clean_weekly_sales
    GROUP BY month_number, calendar_year, platform
)

SELECT
    month_number,
    calendar_year,
    ROUND(100 * MAX(CASE WHEN platform = 'retail' THEN monthly_sales ELSE NULL END) / SUM(monthly_sales), 2) AS retail_percentage,
    ROUND(100 * MAX(CASE WHEN platform = 'shopify' THEN monthly_sales ELSE NULL END) / SUM(monthly_sales), 2) AS shopify_percentage
FROM cte_monthly_platform_sales
GROUP BY month_number, calendar_year;

-------------Q6>>>>what is percentage of sales by demographic for each demographic<<<<<---------------
select calendar_year,demographic,sum(sales) as yearly_sales,
round(100*sum(sales)/sum(sum(sales))
over (partition by demographic),2) as percentage
from clean_weekly_sales
group by calendar_year,demographic;

-------------Q7>>>>which age_band and demographic contributed to the Retail sales <<<<<---------------
select age_band,demographic,sum(sales) as total_sales
from clean_weekly_sales
where platform='retail'
group by age_band,demographic
order by total_sales desc;






