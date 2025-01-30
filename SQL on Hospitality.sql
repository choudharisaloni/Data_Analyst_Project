Use hospitality;
select * from dim_date;
select * from dim_hotels;
select * from dim_rooms;
select * from fact_aggregated_bookings;
select * from fact_bookings;

-- Total Revenue
select * from fact_bookings;

SELECT 
    SUM(revenue_realized) AS total_revenue
FROM 
    fact_bookings;


-- Occupancy Rate
Select * from fact_aggregated_bookings;

 SELECT
 property_id,
    SUM(successful_bookings) / SUM(capacity) * 100 AS occupancy_rate
FROM 
    fact_aggregated_bookings 
group by property_id;
 
 
-- Cancellation Rate
Select * from fact_bookings;
SELECT 
    SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS cancellation_rate
FROM 
    fact_bookings;
    

-- Total Booking
select * from fact_bookings;

SELECT 
    COUNT(booking_id) AS total_bookings
FROM 
    fact_bookings;


-- Utilize Capacity
select * from fact_aggregated_bookings;

select  sum(successful_bookings) * 100.0 / sum(capacity) as Utilization_Rate
from fact_aggregated_bookings;

-- Trend Analysis
 
 select * from fact_bookings;
select * from dim_date;

SELECT 
    DATE_FORMAT(booking_date, '%Y-%m') AS month, 
    SUM(revenue_realized) AS total_revenue
FROM fact_bookings
GROUP BY 
    DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY 
    month;


-- weekday & weekend Revenue and Booking

select * from fact_bookings;
select * from dim_date;

SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(booking_date, '%Y-%m-%d')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type, 
    COUNT(*) AS total_bookings, 
    SUM(revenue_realized) AS total_revenue
FROM fact_bookings

GROUP BY day_type
ORDER BY FIELD(day_type, 'Weekday', 'Weekend');


-- Revenue by state & hotel
-- 1. Revenue by state
select * from fact_bookings;
select * from dim_hotels; 
SELECT 
    h.city, 
     SUM(f.revenue_realized) AS total_revenue
FROM 
    dim_hotels h
JOIN 
    fact_bookings f
ON 
    h.property_id = f.property_id
GROUP BY 
    h.city
ORDER BY 
    h.city ASC, 
    total_revenue DESC;
    
        
-- 2. Revenue by hotel

select * from fact_bookings;
select * from dim_hotels; 

SELECT 
    h.property_name, 
    SUM(f.revenue_realized) AS total_revenue
FROM 
    dim_hotels h
JOIN 
    fact_bookings f
ON 
    h.property_id = f.property_id
GROUP BY 
    h.property_name
ORDER BY 
    total_revenue DESC;




-- class wise Revenue
select * from dim_hotels;
select * from fact_bookings;

SELECT 
    dh.category AS hotel_class,
    SUM(fb.revenue_realized) AS total_revenue
FROM 
    dim_hotels dh
INNER JOIN 
    fact_bookings fb
ON 
    dh.property_id = fb.property_id
GROUP BY 
    dh.category
ORDER BY 
    total_revenue DESC;




-- checked out cancel No show

select * from fact_bookings;

select booking_status, count(booking_status) as Count from fact_bookings
where booking_status in ('Checked Out', 'Cancelled', 'No show')
group by booking_status;



-- weekly trend key trend (Revenue,Total booking,Occupancy)

Select * from fact_bookings;
select * from  dim_date;

--  change column name

alter table dim_date
change column `week no` week_no text;

# replace W from Week column
UPDATE dim_date
SET week_no = REPLACE(week_no, 'W ', '');

# update the column with the correct DATE values

UPDATE dim_date 
SET date = STR_TO_DATE(date, '%d-%b-%y') 
WHERE date REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{2}$';

# alter the column to the DATE data type
ALTER TABLE dim_date
MODIFY date DATE;

SELECT
    dd.`week_no` AS WeekNumber,
    dd.`mmm yy` AS MonthYear,
    COUNT(fb.booking_id) AS TotalBookings,
    SUM(fb.revenue_generated) AS TotalRevenue,
    AVG(fb.no_guests) AS AverageOccupancy
FROM
    fact_bookings fb
JOIN
    dim_date dd ON DATE(fb.booking_date) = DATE(dd.date)
GROUP BY
    dd.`week_no`, dd.`mmm yy`
ORDER BY
    dd.`mmm yy`, dd.`week_no`;






