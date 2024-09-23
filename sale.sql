use covid;
select * from sale limit 3;
describe sale;
alter table sale add column time_day varchar(10),
add column name_day varchar(10),
add column mon_name varchar(30); 
update sale set date=str_to_date(date,'%d-%m-%Y');
update sale set time_day=case when hour(time)<12 then 'moring' else 'evening' end,
name_day=case when dayofWeek(date)=1 then 'sunday' when dayofWeek(date)=2 then 'monday'
 when dayofWeek(date)=3 then 'tuesday' when dayofWeek(date)=4 then 'wednesday' when dayofweek(date)=5 then 'thursday'
 when dayofweek(date)=6 then 'Friday' else 'saturday' end;
 update sale set mon_name=date_format(date,'%b');
 select * from sale limit 3;
 
 #real one
 select distinct(productline) from sale;
 select Distinct(city) from sale;
 select city,branch from sale group by city,branch;

SELECT COUNT(DISTINCT(productline)) FROM sale; #count of different product from sale

SELECT a.payment from (select payment,count(payment) from sale
 group by payment order by count(payment) desc) as a limit 1;
 
with sellingproduct as(select productline,count(productline) 
as j from sale group by productline order by j desc limit 1)
select productline from sellingproduct; 

with totalmonthsale as (select mon_name,sum(total)as sale2 from sale group by mon_name),
totalcogs as(select mon_name,sum(cogs)as d from sale group by mon_name)
select g.d,g.mon_name,b.sale2 from totalcogs g right join
(select * from totalmonthsale) as b on g.mon_name=b.mon_name; 

with mostsaleproduct as (select productline,sum(unit_price*quantity) from 
sale group by prouctline having sum(unit_price* quantity)=(select 
max(sum(unit_price*quantity)) from
select sum(unit_price*quantity) from sale group by prouctline)as subquery)));

WITH mostsaleproduct AS (
    SELECT productline, SUM(unit_price * quantity) AS total_sales
    FROM sale
    GROUP BY productline
    HAVING SUM(unit_price * quantity) = (
        SELECT MAX(total_sales)
        FROM (
            SELECT SUM(unit_price * quantity) AS total_sales
            FROM sale
            GROUP BY productline
        ) AS subquery
    )
)

SELECT *
FROM mostsaleproduct;
select * from sale limit 2;

with largestrevenue as (
SELECT CITY from sale group by city
having sum(total-unit_price)=(select max(a) from 
(select sum(total-unit_price) as a from sale group by city) as subquery
))
select * from largestrevenue;

select * from sale limit 3;

alter table sale add column vat int;
update sale set vat=5*cogs ;
with call1 as (select productline,rank() over(order by j desc) l,j  from ( select 
productline,sum(vat) as j from sale group by productline)as k )
select productline  from call1 where l=1;
select * from sale limit 1;
with avgsale as (select avg(j) from (select productline,count(productline) as j from sale group by productline)as b)
select * from avgsale; 
alter table sale add column product varchar(10);
update sale
set product=case when (select sum(productline) from sale 
group by productline)>(select avg(j)
from (select productline,count(productline) 
as j from sale group by productline) as b) then 'good' else 'bad' end ;

with mostsale as(select case when (select sum(product)>
(select avg(j) from (select branch ,
count(productline)as j from sale group by branch)as o) )then 'good' else
'bad' end as j from sale group by branch) 
select * from mostsale;

select * from sale limit 4;

with class4 as(select gender,productline,count(productline)  as b from sale where gender='Male' group by gender,productline order by b desc )
select productline from class4 limit 1;
with class1 as (select gender,productline,count(productline)as b from sale where gender='Female' group by gender,productline
order by b desc)
select productline from class1 limit 1; 
select productline,round(avg(rating),2) as averagerating from sale group by productline;

select count(distinct(payment)) as they from sale;
with a as (select case when (select count(gender) from sale where gender='Male')>(select count(gender) from sale where
gender='Female') then 'Male' else 'Female' end as most)
select * from a;

with b as (select branch,gender,count(gender) from sale group by gender,branch order by branch)
select * from b;
select * from sale limit 4;
with mostrat as(select time_day,count(rating) as most from sale group by time_day)
select * from mostrat order by most limit 1;
with mostrat as(select name_day ,count(rating) as most from sale group by name_day)
select * from mostrat order by most limit 1; 
select * from(select branch,name_day,count(rating) as co2 from sale group by branch,name_day )as j
inner join 
(select   branch,max(c) as max1 from (select branch,name_day,count(rating) as c 
from sale group by branch,name_day) as b group by branch)as c on c.branch=j.branch and c.max1=j.co2 
limit 3;

