-- Task 1: Identifying the Top Branch by Sales Growth Rate

select 
       Branch, 
       round(sum(total),2) as total_sales, 
       month(str_to_date(date,"%d-%m-%Y")) as sale_month
from walmartsales
group by 
	    month(str_to_date(date,"%d-%m-%Y")), 
        branch
order by total_sales desc;

-- Task 2: Finding the Most Profitable Product Line for Each Branch 

select 
      branch, 
      `product line`,
      max_profit_margin,
      rn 
from 
    (
      select branch, `product line`, round(max(total- `gross income`),2) as max_profit_margin, 
      rank() over (partition by branch order by round(max(total- `gross income`),2) desc) as rn
	  from walmartsales
	  group by branch, `product line`
	) as subquery
where rn =1
order by max_profit_margin desc;

-- Task 3: Analyzing Customer Segmentation Based on Spending

select distinct `customer ID`, round(sum(total),2) as total_amount_spent,
case
when sum(total) < 20000 then 'Low Spender'
when sum(total) < 23000 then 'Medium Spender'
else 'High Spender'
end as spending_behaviour
from walmartsales
group by `Customer ID`
order by Sum(total) desc;
 
-- Task 4: Detecting Anomalies in Sales Transactions

with AvgSales as (
     select 
           `product line`, 
           avg(total) as avg_sales
	 from 
          walmartsales
	group by 
           `Product line`
)
select 
      w.`Product line`, `Customer ID`, total,
      a.avg_sales,
      case
          when w.total < 
a.avg_sales * 0.5 then 'Low Sales'
		  when w.total > 
a.avg_sales * 1.5 then 'High Sales'
          else 'Normal Sales'
		end as sales_anomaly
from 
    walmartsales w
join 
	Avgsales a on 
w.`Product line` = a.`product line`
where 
     w.total < a.avg_sales * 0.5
or w.Total > a.avg_sales * 1.5;

-- Task 5: Most Popular Payment Method by City.

select 
       payment, 
       city, 
       count(payment) as popular_method 
from walmartsales
where Payment in 
                (select max(payment) from walmartsales)
group by Payment, city;

-- Task 6: Monthly Sales Distribution by Gender.

select 
       gender,  
       month(str_to_date(date,"%d-%m-%Y")) as sale_month, 
       count(*) as total_sales
from walmartsales
group by gender, month(str_to_date(date,"%d-%m-%Y"));

-- Task 7: Best Product Line by Customer Type

select 
      `product line`, 
      `Customer Type`, 
      total_customers, 
      rn
from 
    ( 
     select `product line`, `Customer Type`, count(`customer type`) as total_customers,
rank() over(partition by `product line` order by count(`customer type`) desc) as rn
from walmartsales
group by `product line`, `Customer Type`
     ) as subquery
where rn =1;
                                   
         
--  Task 8: Identifying Repeat Customers

select 
       distinct `customer ID`, 
       month(str_to_date(date,"%d-%m-%Y")) as sale_month, 
       count(`customer ID`) as customer_repeat_count
from walmartsales 
where month(str_to_date(date,"%d-%m-%Y")) = 1
group by `customer ID`, month(str_to_date(date,"%d-%m-%Y"))
order by `customer ID`;

-- Task 9: Finding Top 5 Customers by Sales Volume

select 
	  distinct `customer ID`, 
      round(sum(total),2) as top_total 
from walmartsales
group by `customer ID`
order by top_total desc
limit 5;

-- Task 10: Analyzing Sales Trends by Day of the Week

-- 1 stands for sunday in wee_days

select 
      dayofweek(str_to_date(date,"%d-%m-%Y")) as week_days, 
      round(sum(total),2) as total_revenue
from walmartsales
group by week_days
order by total_revenue desc;





