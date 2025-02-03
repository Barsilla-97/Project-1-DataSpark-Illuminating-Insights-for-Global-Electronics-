create table StoreSalesByCountry
    select st.Country, sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join stores st
    on s.StoreKey = st.StoreKey
    join products p
    on s.ProductKey = p.ProductKey
    where Country != "Online"
    group by st.Country
    order by total_revenue desc;
    
select st.Country, sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join stores st
    on s.StoreKey = st.StoreKey
    join products p
    on s.ProductKey = p.ProductKey
    where Country != "Online"
    group by st.Country
    order by total_revenue desc;
    
create table StorePerformance
    select st.StoreKey, st.Country, st.State, st.Square_Meters, st.Open_Date,
    timestampdiff(year, st.Open_Date, curdate()) as store_age_years,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) / st.Square_Meters as sales_per_sqm,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) / timestampdiff(year, st.Open_Date, curdate()) as sales_per_year
    from sales s
    join stores st
    on s.StoreKey = st.StoreKey
    join products p
    on s.ProductKey = p.ProductKey
    where Country != "Online"
    group by st.StoreKey, st.Country, st.State, st.Square_Meters, st.Open_Date
    order by total_revenue desc;
    
Create table CatAndSubSales
    select p.Category, p.Subcategory, sum(s.Quantity) as totalQuantitySold,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    group by p.Category, p.Subcategory
    order by total_revenue desc;
    
select p.Category, p.Subcategory, sum(s.Quantity) as totalQuantitySold,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    group by p.Category, p.Subcategory
    order by total_revenue desc;
    
create table ProfitMargins
    select p.ProductKey, p.Product_Name, p.Brand, p.Unit_Cost_USD, p.Unit_Price_USD,
    ((cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2)) 
    - cast(replace(p.Unit_Cost_USD, '$', '') as decimal(10,2))) 
    / cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) * 100 as ProfitMargin
    from products p;
    
select p.ProductKey, p.Product_Name, p.Brand, p.Unit_Cost_USD, p.Unit_Price_USD,
    ((cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2)) 
    - cast(replace(p.Unit_Cost_USD, '$', '') as decimal(10,2))) 
    / cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) * 100 as ProfitMargin
    from products p;
    
create table PopularProducts
    select p.ProductKey, p.Product_Name, p.Brand, sum(s.Quantity) as total_quantity_sold
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    group by p.ProductKey, p.Product_Name, p.Brand
    order by total_quantity_sold desc;
    
select p.ProductKey, p.Product_Name, p.Brand, sum(s.Quantity) as total_quantity_sold
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    group by p.ProductKey, p.Product_Name, p.Brand
    order by total_quantity_sold desc;
    
create table SalesByCurrency
    select s.Currency_Code as Currency,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2)) * er.Exchange) as total_sales_in_currency
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    join exchangerates er
    on s.Order_Date = er.Date and s.Currency_Code = er.Currency
    group by s.Currency_Code
    order by total_sales_in_currency desc;
    
select s.Currency_Code as Currency,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2)) * er.Exchange) as total_sales_in_currency
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    join exchangerates er
    on s.Order_Date = er.Date and s.Currency_Code = er.Currency
    group by s.Currency_Code
    order by total_sales_in_currency desc;
    
create table SalesByCountry
    select st.Country, sum(s.Quantity) as total_quantity_sold,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    join stores st
    on s.StoreKey = st.StoreKey
    where Country != "Online"
    group by st.Country
    order by total_revenue desc;
    
select st.Country, sum(s.Quantity) as total_quantity_sold,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    join stores st
    on s.StoreKey = st.StoreKey
    where Country != "Online"
    group by st.Country
    order by total_revenue desc;
    
create table SalesByCategory
    select p.Category, sum(s.Quantity) as total_quantity_sold, 
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    group by p.Category
    order by total_revenue desc;
    
select p.Category, sum(s.Quantity) as total_quantity_sold, 
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    group by p.Category
    order by total_revenue desc;
    
select * from salesandproducts;

select p.ProductKey, p.Product_Name, p.Brand, p.Color, p.Unit_Cost_USD, p.Unit_Price_USD, p.Subcategory,
    p.Category, s.Order_Number, s.Order_Date, s.Quantity, s.Currency_Code,
    er.Date, er.Currency, er.Exchange 
    from sales s
	inner join products p
	on s.ProductKey = p.ProductKey
    left join exchangerates er
    on s.Currency_Code = er.Currency and s.Order_Date = er.Date;
    
select p.ProductKey, p.Product_Name, p.Brand, p.Color, p.Unit_Cost_USD, p.Unit_Price_USD, p.Subcategory,
    p.Category, s.Order_Number, s.Order_Date, s.Quantity, s.Currency_Code from sales s
	inner join products p
	on s.ProductKey = p.ProductKey;
    
create table SeasonalitySales
    select year(Order_Date) as year, quarter(Order_Date) as quarter, sum(Quantity) as total_quantity_sold
    from sales
    group by year(Order_Date), quarter(Order_Date)
    order by year desc, quarter;
    
select year(Order_Date) as year, quarter(Order_Date) as quarter, sum(Quantity) as total_quantity_sold
    from sales
    group by year(Order_Date), quarter(Order_Date)
    order by year desc, quarter;
    
create table TrendsOnSales
    select year(Order_Date) as year, month(Order_Date) as month, sum(Quantity) as total_quantity_sold
    from sales
    group by year(Order_Date), month(Order_Date)
    order by year desc, month desc;
    
select year(Order_Date) as year, month(Order_Date) as month, sum(Quantity) as total_quantity_sold
    from sales
    group by year(Order_Date), month(Order_Date)
    order by year desc, month desc;
    
create table TotalSales
    select year(Order_Date) as year, sum(Quantity) as total_quantity_sold
    from sales
    group by year(Order_Date)
    order by year(Order_Date);
    
select year(Order_Date) as year, sum(Quantity) as total_quantity_sold
    from sales
    group by year(Order_Date)
    order by year(Order_Date);
select * from Customerproductsales;

select p.Category, p.Subcategory, sum(s.Quantity) as totalQuantitySold,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join products p
    on s.ProductKey = p.ProductKey
    group by p.Category, p.Subcategory
    order by total_revenue desc;
    
select st.StoreKey, st.Country, st.State, st.Square_Meters, st.Open_Date,
    timestampdiff(year, st.Open_Date, curdate()) as store_age_years,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) / st.Square_Meters as sales_per_sqm,
    sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) / timestampdiff(year, st.Open_Date, curdate()) as sales_per_year
    from sales s
    join stores st
    on s.StoreKey = st.StoreKey
    join products p
    on s.ProductKey = p.ProductKey
    where Country != "Online"
    group by st.StoreKey, st.Country, st.State, st.Square_Meters, st.Open_Date
    order by total_revenue desc;
    
select st.Country, sum(s.Quantity * cast(replace(p.Unit_Price_USD, '$', '') as decimal(10,2))) as total_revenue
    from sales s
    join stores st
    on s.StoreKey = st.StoreKey
    join products p
    on s.ProductKey = p.ProductKey
    where Country != "Online"
    group by st.Country
    order by total_revenue desc;
    
select CustomerKey, sum(cast(replace(Unit_Price_USD, '$', '') as decimal(10,2))) / count(Order_Number) as AOV
from Customerproductsales
group by CustomerKey;

select CustomerKey, count(Order_Number) / count(distinct year(Order_Date)) as avg_orders_per_year
from Customerproductsales
group by CustomerKey;

select CustomerKey, sum(cast(replace(Unit_Price_USD, '$', '') as decimal(10,2))) / count(Order_Number) as AOV
from Customerproductsales
group by CustomerKey;

select CustomerKey, count(Order_Number) / count(distinct year(Order_Date)) as avg_orders_per_year
from Customerproductsales
group by CustomerKey;

select * from customers;
select timestampdiff(year, Birthday, curdate())
from Customers;

use project1;


