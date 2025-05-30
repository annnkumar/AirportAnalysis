
USE airport_db;
SHOW TABLES;
ALTER TABLE airp RENAME TO airports2;


select* from airports2 limit 3;


# 1

#The objective is to calculate the total number of 
#passengers for each pair of origin and destination airports.

 select 
     origin_airport, destination_airport, SUM(passengers)  as total_ppassengers from airports2 
     group by origin_airport , destination_airport order by origin_airport , destination_airport;





#Problem Statement 2
#Objective:

#Calculate the average seat utilization for each flight by dividing the number of passengers by the total number of seats available, sorted in descending order based on utilization percentage, to identify flights with the highest and lowest seat occupancy for optimizing flight operations.

SELECT
    Origin_airport,
    Destination_airport,
    AVG(CAST(Passengers AS FLOAT) / NULLIF(Seats, 0)) * 100 AS Average_Seat_Utilization
FROM
    airports2
GROUP BY
    Origin_airport,
    Destination_airport
ORDER BY
    Average_Seat_Utilization DESC;
    

#Problem Statement 3
#Objective:

#Determine the top 5 origin and destination airport pairs with the highest total passenger volume to reveal the most frequented travel routes, allowing airlines to optimize resource allocation and enhance service offerings based on passenger demand trends.

SELECT
    Origin_airport,
    Destination_airport,
    SUM(Passengers) AS Total_Passengers
FROM
    airports2
GROUP BY
    Origin_airport,
    Destination_airport
ORDER BY
    Total_Passengers DESC
LIMIT 5;



#Problem Statement 4
#Objective:

#Calculate the total number of flights and passengers departing from each origin city to provide insights into activity levels at various origin cities, helping identify key hubs and inform strategic decisions regarding flight operations and capacity management.


SELECT 
    origin_city,
    COUNT(Flights) AS Total_Flights,
    SUM(Passengers) AS Total_Passengers
FROM 
    airports2
GROUP BY 
    origin_city
ORDER BY 
    origin_city ;
    
    
#Problem Statement 5
#Objective:

#Calculate the total distance flown by flights originating from each airport to offer insights into the overall travel patterns and operational reach, helping evaluate their significance in the network and inform future route planning decisions.

SELECT 
    Origin_airport,
    SUM(Distance) AS Total_Distance
FROM 
    airports2
GROUP BY 
    Origin_airport
ORDER BY 
    total_distance desc;
    

#Problem Statement 6
#Objective:

#Group flights by month and year using the Fly_date column to calculate the number of flights, total passengers, and average distance traveled per month to understand seasonal trends and operational performance over time for better strategic planning.


SELECT
    YEAR(Fly_date) AS Year,
    MONTH(Fly_date) AS Month,
    COUNT(Flights) AS Total_Flights,
    SUM(Passengers) AS Total_Passengers,
    AVG(Distance) AS Avg_Distance
FROM
    airports2
GROUP BY
    YEAR(Fly_date),
    MONTH(Fly_date)
ORDER BY
    Year,
    Month;
    
#Problem Statement 7
#Objective:

#Calculate the passenger-to-seats ratio for each origin and destination route and filter results to display only routes with a ratio less than 0.5 to identify underutilized routes, enabling informed decisions about capacity management and potential route adjustments.

SELECT
    Origin_airport,
    Destination_airport,
    SUM(Passengers) AS Total_Passengers,
    SUM(Seats) AS Total_Seats,
    (SUM(Passengers) * 1.0 / NULLIF(SUM(Seats), 0)) AS Passenger_to_Seats_Ratio
FROM
    airports2
GROUP BY
    Origin_airport,
    Destination_airport
HAVING
    (SUM(Passengers) * 1.0 / NULLIF(SUM(Seats), 0)) < 0.5
ORDER BY
    Passenger_to_Seats_Ratio desc;
    


#Problem Statement 8
#Objective:

#Determine the top 3 origin airports with the highest frequency of flights to highlight the most active airports in terms of flight operations, providing insights for optimizing scheduling and improving service offerings.

SELECT
    origin_airport,
    COUNT(Flights) AS Total_Flights
FROM
    airports2
GROUP BY
    origin_airport
ORDER BY
    Total_Flights DESC
LIMIT 3;


#Problem Statement 9
#Objective:

#Identify the city (excluding Bend, OR) that sends the most flights and passengers to Bend, OR to reveal key contributors to passenger traffic, helping understand demand patterns and enhance connectivity from popular originating cities.

SELECT 
    Origin_city,
    COUNT(Flights) AS Total_Flights,
    SUM(Passengers) AS Total_Passengers
FROM 
    airports2
WHERE 
    Destination_city = 'Bend, OR' AND 
    Origin_city <> 'Bend, OR'
GROUP BY 
    Origin_city
ORDER BY 
    Total_Flights DESC,
    Total_Passengers DESC
LIMIT 3;

#Problem Statement 10
#Objective:

#Identify the longest flight route in terms of distance traveled, including both origin and destination airports, to provide insights into the most extensive travel connections for assessing operational challenges and opportunities for long-haul service planning.
##SQL Query:
##(Note: The document does not provide a complete SQL query for Problem Statement 10, only repeating the objective multiple times. Based on the objective, a suitable query would be:)




SELECT
    Origin_airport,
    Destination_airport,
    MAX(Distance) AS Max_Distance
FROM
    airports2
GROUP BY
    Origin_airport,
    Destination_airport
ORDER BY
    Max_Distance DESC;
    

##Problem Statement 11
#Objective:

#Determine the most and least busy months by flight count across multiple years to provide insights into seasonal trends in air travel, helping airlines understand peak and off-peak periods for better operational planning and resource allocation.



with monthly_flights as (

  select 
      month(fly_date) as month,
      count(flights) as total_flights
      from airports2
      group by 
         month(fly_date)
         
)
 select month , total_flights,
    case 
       when total_flights = (select max(total_flights) from monthly_flights)  then 'Most Busy'
       when total_flights = (select min(total_flights) from monthly_flights) then 'least busy'
       else null
	end as month_status 
from 
   monthly_flights
where 
   Total_Flights = (SELECT MAX(Total_Flights) FROM Monthly_Flights) 
    OR Total_Flights = (SELECT MIN(Total_Flights) FROM Monthly_Flights);
    


#Problem Statement 12
#Objective:

#Identify trends in passenger traffic over time by calculating year-over-year passenger growth for each origin-destination pair, providing insights for airlines to make informed decisions about route development and capacity management based on demand fluctuations.

WITH Passenger_Summary AS (
    SELECT
        Origin_airport,
        Destination_airport,
        YEAR(Fly_date) AS Year,
        SUM(Passengers) AS Total_Passengers
    FROM
        airports2
    GROUP BY
        Origin_airport,
        Destination_airport,
        YEAR(Fly_date)
),
Passenger_Growth AS (
    SELECT
        Origin_airport,
        Destination_airport,
        Year,
        Total_Passengers,
        LAG(Total_Passengers) OVER (
            PARTITION BY Origin_airport,
            Destination_airport
            ORDER BY Year
        ) AS Previous_Year_Passengers
    FROM
        Passenger_Summary
)
SELECT
    Origin_airport,
    Destination_airport,
    Year,
    Total_Passengers,
    CASE
        WHEN Previous_Year_Passengers IS NOT NULL THEN
            ((Total_Passengers - Previous_Year_Passengers) * 100.0 / NULLIF(Previous_Year_Passengers, 0))
        ELSE NULL
    END AS Growth_Percentage
FROM
    Passenger_Growth
ORDER BY
    Origin_airport,
    Destination_airport,
    Year;
    

#Problem Statement 13
#Objective:

#Identify routes (origin to destination) that have demonstrated consistent year-over-year growth in the number of flights to highlight successful routes, providing insights for airlines to strengthen operational strategies and consider potential expansions based on sustained demand trends.


WITH Flight_Summary AS (
    SELECT
        Origin_airport,
        Destination_airport,
        YEAR(Fly_date) AS Year,
        COUNT(Flights) AS Total_Flights
    FROM
        airports2
    GROUP BY
        Origin_airport,
        Destination_airport,
        YEAR(Fly_date)
),
Flight_Growth AS (
    SELECT
        Origin_airport,
        Destination_airport,
        Year,
        Total_Flights,
        LAG(Total_Flights) OVER (PARTITION BY Origin_airport, Destination_airport ORDER BY Year) AS Previous_Year_Flights
    FROM
        Flight_Summary
),
Growth_Rates AS (
    SELECT
        Origin_airport,
        Destination_airport,
        Year,
        Total_Flights,
        CASE
            WHEN Previous_Year_Flights IS NOT NULL AND Previous_Year_Flights > 0 THEN
                ((Total_Flights - Previous_Year_Flights) * 100.0 / Previous_Year_Flights)
            ELSE NULL
        END AS Growth_Rate,
        CASE
            WHEN Previous_Year_Flights IS NOT NULL AND Total_Flights > Previous_Year_Flights THEN 1
            ELSE 0
        END AS Growth_Indicator
    FROM
        Flight_Growth
)
SELECT
    Origin_airport,
    Destination_airport,
    MIN(Growth_Rate) AS Minimum_Growth_Rate,
    MAX(Growth_Rate) AS Maximum_Growth_Rate
FROM
    Growth_Rates
WHERE
    Growth_Indicator = 1
GROUP BY
    Origin_airport,
    Destination_airport
HAVING
    MIN(Growth_Indicator) = 1
ORDER BY
    Origin_airport,
    Destination_airport;


#Problem Statement 14
#Objective:

#Highlight the top 3 origin airports with good passenger-to-seat ratios and high flight volumes by calculating weighted utilization, providing a balanced view of operational efficiency for optimizing scheduling and resource allocation.
#SQL Query:


WITH Utilization_Ratio AS (
    SELECT
        Origin_airport,
        SUM(Passengers) AS Total_Passengers,
        SUM(Seats) AS Total_Seats,
        COUNT(Flights) AS Total_Flights,
        SUM(Passengers) * 1.0 / SUM(Seats) AS Passenger_Seat_Ratio
    FROM
        airports2
    GROUP BY
        Origin_airport
),
Weighted_Utilization AS (
    SELECT
        Origin_airport,
        Total_Passengers,
        Total_Seats,
        Total_Flights,
        Passenger_Seat_Ratio,
        (Passenger_Seat_Ratio * Total_Flights) / SUM(Total_Flights) OVER () AS Weighted_Utilization
    FROM
        Utilization_Ratio
)
SELECT
    Origin_airport,
    Total_Passengers,
    Total_Seats,
    Total_Flights,
    Weighted_Utilization
FROM
    Weighted_Utilization
ORDER BY
    Weighted_Utilization DESC
LIMIT 3;


#Problem Statement 15
#Objective:

#Identify the peak traffic month for each origin city based on the highest number of passengers, including any ties, to reveal seasonal travel patterns, enabling airlines to tailor services and marketing strategies to meet demand effectively.



WITH Monthly_Passenger_Count AS (
    SELECT
        Origin_city,
        YEAR(Fly_date) AS Year,
        MONTH(Fly_date) AS Month,
        SUM(Passengers) AS Total_Passengers
    FROM
        airports2
    GROUP BY
        Origin_city,
        YEAR(Fly_date),
        MONTH(Fly_date)
),
Max_Passengers_Per_City AS (
    SELECT
        Origin_city,
        MAX(Total_Passengers) AS Peak_Passengers
    FROM
        Monthly_Passenger_Count
    GROUP BY
        Origin_city
)
SELECT
    mpc.Origin_city,
    mpc.Year,
    mpc.Month,
    mpc.Total_Passengers
FROM
    Monthly_Passenger_Count mpc
JOIN
    Max_Passengers_Per_City mp ON mpc.Origin_city = mp.Origin_city
    AND mpc.Total_Passengers = mp.Peak_Passengers
ORDER BY
    mpc.Origin_city,
    mpc.Year,
    mpc.Month;
    
    
    
#Problem Statement 16
#Objective:

#Identify the routes (origin-destination pairs) that have experienced the largest decline in passenger numbers year-over-year to pinpoint routes facing reduced demand, allowing strategic adjustments in operations, marketing, and service offerings.
#SQL Query:
WITH Yearly_Passenger_Count AS (
    SELECT
        Origin_airport,
        Destination_airport,
        YEAR(Fly_date) AS Year,
        SUM(Passengers) AS Total_Passengers
    FROM
        airports2
    GROUP BY
        Origin_airport,
        Destination_airport,
        YEAR(Fly_date)
),
Yearly_Decline AS (
    SELECT
        y1.Origin_airport,
        y1.Destination_airport,
        y1.Year AS Year1,
        y1.Total_Passengers AS Passengers_Year1,
        y2.Year AS Year2,
        y2.Total_Passengers AS Passengers_Year2,
        ((y2.Total_Passengers - y1.Total_Passengers) / NULLIF(y1.Total_Passengers, 0)) * 100 AS Percentage_Change
    FROM
        Yearly_Passenger_Count y1
    JOIN
        Yearly_Passenger_Count y2
        ON y1.Origin_airport = y2.Origin_airport
        AND y1.Destination_airport = y2.Destination_airport
        AND y2.Year = y1.Year + 1
)
SELECT
    Origin_airport,
    Destination_airport,
    Year1,
    Year2,
 sas
    Passengers_Year1,
    Passengers_Year2,
    Percentage_Change
FROM
    Yearly_Decline
WHERE
    Percentage_Change < 0
ORDER BY
    Percentage_Change ASC
LIMIT 5;


#Problem Statement 17
#Objective:

#List all origin and destination airports with at least 10 flights but an average seat utilization of less than 50% to highlight underperforming routes, enabling airlines to reassess capacity management strategies and optimize seat utilization.


WITH Flight_Stats AS (
    SELECT
        Origin_airport,
        Destination_airport,
        COUNT(Flights) AS Total_Flights,
        SUM(Passengers) AS Total_Passengers,
        SUM(Seats) AS Total_Seats,
        (SUM(Passengers) / NULLIF(SUM(Seats), 0)) AS Avg_Seat_Utilization
    FROM
        airports2
    GROUP BY
        Origin_airport, Destination_airport
)
SELECT
    Origin_airport,
    Destination_airport,
    Total_Flights,
    Total_Passengers,
    Total_Seats,
    ROUND(Avg_Seat_Utilization * 100, 2) AS Avg_Seat_Utilization_Percentage
FROM
    Flight_Stats
WHERE
    Total_Flights >= 10
    AND Avg_Seat_Utilization < 0.5
ORDER BY
    Avg_Seat_Utilization_Percentage ASC;
    
#Problem Statement 18
#Objective:

#Calculate the average flight distance for each unique city-to-city pair and identify routes with the longest average distance to provide insights into long-haul travel patterns, aiding operational and market opportunity assessments.


WITH Distance_Stats AS (
    SELECT
        Origin_city,
        Destination_city,
        AVG(Distance) AS Avg_Flight_Distance
    FROM
        airports2
    GROUP BY
        Origin_city,
        Destination_city
)
SELECT
    Origin_city,
    Destination_city,
    ROUND(Avg_Flight_Distance, 2) AS Avg_Flight_Distance
FROM
    Distance_Stats
ORDER BY
    Avg_Flight_Distance DESC;
    
#Problem Statement 19
#Objective:

#Calculate the total number of flights and passengers for each year, along with the percentage growth in both flights and passengers compared to the previous year, to provide a comprehensive overview of annual trends in air travel for strategic decision-making.

WITH Yearly_Summary AS (
    SELECT
        SUBSTR(Fly_date, 7, 4) AS Year,
        COUNT(Flights) AS Total_Flights,
        SUM(Passengers) AS Total_Passengers
    FROM
        airports2
    GROUP BY
        SUBSTR(Fly_date, 7, 4)
),
Yearly_Growth AS (
    SELECT
        Year,
        Total_Flights,
        Total_Passengers,
        LAG(Total_Flights) OVER (ORDER BY Year) AS Prev_Flights,
        LAG(Total_Passengers) OVER (ORDER BY Year) AS Prev_Passengers
    FROM
        Yearly_Summary
)
SELECT
    Year,
    Total_Flights,
    Total_Passengers,
    ROUND(((Total_Flights - Prev_Flights) / NULLIF(Prev_Flights, 0) * 100), 2) AS Flight_Growth_Percentage,
    ROUND(((Total_Passengers - Prev_Passengers) / NULLIF(Prev_Passengers, 0) * 100), 2) AS Passenger_Growth_Percentage
FROM
    Yearly_Growth
ORDER BY
    Year;
    
#Problem Statement 20
#Objective:

#Highlight the most significant routes in terms of distance and operational activity by calculating weighted distance (total distance * total flights) to optimize scheduling and resource allocation strategies.


WITH Route_Distance AS (
    SELECT
        Origin_airport,
        Destination_airport,
        SUM(Distance) AS Total_Distance,
        SUM(Flights) AS Total_Flights
    FROM
        airports2
    GROUP BY
        Origin_airport,
        Destination_airport
),
Weighted_Routes AS (
    SELECT
        Origin_airport,
        Destination_airport,
        Total_Distance,
        Total_Flights,
        Total_Distance * Total_Flights AS Weighted_Distance
    FROM
        Route_Distance
)
SELECT
    Origin_airport,
    Destination_airport,
    Total_Distance,
    Total_Flights,
    Weighted_Distance
FROM
    Weighted_Routes
ORDER BY
    Weighted_Distance DESC
LIMIT 3;

    