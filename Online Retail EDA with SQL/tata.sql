drop table if exists retail_store;

create table retail_store(InvoiceNo varchar(25),StockCode varchar(25),Description varchar(350),Quantity int,
						 InvoiceDate timestamp,UnitPrice float,CustomerID int,Country varchar(50));
						 
copy retail_store from 'G:\MySQL\SelfPractice Dataset\Tata\Online_Retail.csv' with delimiter ',' csv header encoding 'windows-1251';

select * from retail_store;
select count(distinct(country)) from retail_store;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'retail_store';


select distinct(InvoiceDate) from retail_store;
select min(InvoiceDate) from retail_store;
select max(InvoiceDate) from retail_store;

#Maximum Quantity order
select min(Quantity) from retail_store;
select max(Quantity) from retail_store;


select max(Quantity),Country from retail_store group by Country order by max(Quantity) desc limit 5;
select max(Quantity),Country from retail_store group by Country order by max(Quantity) limit 5;

#Maximum orders by description and country

select * from retail_store;

select count(Description) from retail_store;
select distinct Description from retail_store;
select invoiceno,Description, country,Quantity from retail_store group by (invoiceno),Description, country,Quantity 
having sum(Quantity) >1000 order by Quantity desc limit 5

select invoiceno,Description, country,Quantity from retail_store group by (invoiceno),Description, country,Quantity 
having sum(Quantity) order by Quantity limit 5

select country,sum(Quantity) as Total_Quantity from retail_store1 group by country order by sum(Quantity) limit 5;

select distinct sum(Description),Description, country from retail_store group by country,Description 
having country !='United Kingdom' order by sum(Description) desc limit 5 

select distinct Description, country from retail_store group by country,Description having country !='United Kingdom'
order by country

 
#Retention Table
select * from retail_store;

drop table if exists retention_table;

create temporary table retention_table as select *,date(date_trunc('week',invoicedate)) as first_day_of_week from retail_store;
select * from retention_table;

select * from retention_table order by customerid;

drop table if exists first_invoice_date;

create temporary table first_invoice_date as select customerid,min(first_day_of_week) as weekstartday 
from retention_table group by 1 order by 1;
select * from first_invoice_date;

drop table if exists week_diff;
create temporary table week_diff as select a.customerid, a.first_day_of_week,b.weekstartday,(a.first_day_of_week-b.weekstartday)/7 as week_diff_val
from retention_table a inner join first_invoice_date b on a.customerid=b.customerid;
select * from week_diff order by customerid;

select weekstartday,
                   count(distinct case when week_diff_val =0 then customerid end) as week_0,
				   count(distinct case when week_diff_val =1 then customerid end) as week_1,
				   count(distinct case when week_diff_val =2 then customerid end) as week_2,
				   count(distinct case when week_diff_val =3 then customerid end) as week_3,
				   count(distinct case when week_diff_val =4 then customerid end) as week_4,
				   count(distinct case when week_diff_val =5 then customerid end) as week_5,
				   count(distinct case when week_diff_val =6 then customerid end) as week_6,
				   count(distinct case when week_diff_val =7 then customerid end) as week_7,
				   count(distinct case when week_diff_val =8 then customerid end) as week_8,
				   count(distinct case when week_diff_val =9 then customerid end) as week_9,
				   count(distinct case when week_diff_val =10 then customerid end) as week_10
			from week_diff group by 1 order by 1;

select * from retail_store;						


#Create a View of all stock (grouped by the supplier)

select stockcode,description,max(unitprice) from retail_store group by stockcode,description,unitprice order by unitprice desc limit 5;


#Display the growth in sales (as a percentage) for your business

select month(invoicedate) as invoicemonth, sum(quantity) as total_quantity from retail_store


drop table if exists retail_store1;
create table retail_store1(InvoiceNo varchar(25),StockCode varchar(25),Description varchar(350),Quantity int,
						 InvoiceDate timestamp,UnitPrice float,CustomerID int,Country varchar(50));

select * from retail_store1;
copy retail_store1 from 'G:\MySQL\SelfPractice Dataset\Tata\new_file.csv' with delimiter ',' csv header encoding 'windows-1251';
select * from retail_store1;
select * from retail_store;



###No. Of Companies working in

select distinct(country) from retail_store1

##Total Sum of Quantity per country

select country,sum(Quantity) as Total_Quantity from retail_store1 group by country order by sum(Quantity) limit 5;



select * from retail_store;

drop table if exists month_wise;
create temporary table month_wise as select date_part('month',invoicedate) as Month_wise from retail_store
select * from month_wise;

#YearWise/Monthwise Data
select sum(quantity), extract (Year FROM invoicedate) as Year from retail_store group by Year;
select sum(quantity), extract (Month FROM invoicedate) as Month from retail_store group by Month  order by sum(quantity) desc limit 5;

select sum(quantity), extract (Year FROM invoicedate) as Year,extract (Month FROM invoicedate) as Month 
from retail_store group by Year,Month order by sum(quantity) desc limit 5;

#Year wise quantity per country

select country,sum(quantity), extract (Year FROM invoicedate) as Year from retail_store where extract (Year FROM invoicedate)='2011' group by Year,country 
order by sum(quantity) desc limit 5;

#Month wise quantity per country
select country,sum(quantity),extract (Month FROM invoicedate) as Month 
from retail_store group by Month,country 
order by sum(quantity) desc limit 5;


#YearWise customer count
select * from retail_store;
select count(customerid),extract (Year FROM invoicedate) as Year,extract(Month FROM invoicedate) as Month 
from retail_store where extract (Year FROM invoicedate)='2011'  group by Year,Month order by count(customerid) desc limit 5

#Yearwise cusomer count per country in 2011

select country,count(customerid),extract (Year FROM invoicedate) as Year from retail_store
where extract (Year FROM invoicedate)='2011' group by country,Year order by count(customerid) desc limit 10

#Most demanded stockcode with description in UK.
select stockcode,description,country,count(stockcode) from retail_store where country!='United Kingdom'  group by 
stockcode,description,country order by count(stockcode) desc limit 5

select * from retail_store;

#Will calculate revenue per order
#Before revenue will have to get total amount which can be calculate as unit_price*quantity

select description,quantity,unitprice from retail_store;

drop table if exists Revenue1;
create temporary table Revenue1 as select *,(quantity*unitprice) as Revenue from retail_store;
select * from Revenue1;

select sum(Revenue) as Total_revenue from Revenue1

#Total revenue for all description is 9747747.93

select extract (Year FROM invoicedate) as Year,sum(Revenue) as Total_revenue from Revenue1 group by Year;

#Growth Rate in between 2 years is 2.464, or 246.4%.

#MonthWise revenue for all description

select extract(Year FROM invoicedate) as Year,extract(Month FROM invoicedate) as Month,sum(Revenue) as 
Total_revenue from Revenue1 where extract (Year FROM invoicedate)='2011' group by Year,Month order by Total_revenue desc limit 5;

#QuarterWise revenue for all description

SELECT EXTRACT(YEAR FROM invoicedate) AS Year, CONCAT('Q', EXTRACT(QUARTER FROM invoicedate)) AS Quarter,SUM(Revenue) AS Total_revenue
FROM Revenue1 where extract (Year FROM invoicedate)='2011'GROUP BY Year, Quarter ORDER BY Year,Quarter;
