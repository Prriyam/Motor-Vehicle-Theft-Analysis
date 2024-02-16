/* Objective 1 */

/* Find the number of vehicles stolen each year*/
select YEAR(date_stolen) AS Year, count(vehicle_id) As No_of_vehicles_Stolen
from stolen_vehicles
group by Year;

/* Find the number of vehicles stolen each month */
select MONTH(date_stolen) AS Month, count(vehicle_id) AS No_of_vehicles_Stolen
from stolen_vehicles
group by Month
order by Month;

/* Find the number of vehicles stolen each day of the week */
select WEEKDAY(date_stolen) AS Day, count(vehicle_id) AS No_of_vehicles_Stolen
from stolen_vehicles
group by Day
order by Day;

/* Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.) */
select DAYNAME(date_stolen) AS Day, count(vehicle_id) AS No_of_vehicles_Stolen
from stolen_vehicles
group by Day
ORDER BY 
     CASE
          WHEN Day = 'Sunday' THEN 7
          WHEN Day = 'Monday' THEN 1
          WHEN Day = 'Tuesday' THEN 2
          WHEN Day = 'Wednesday' THEN 3
          WHEN Day = 'Thursday' THEN 4
          WHEN Day = 'Friday' THEN 5
          WHEN Day = 'Saturday' THEN 6
     END ASC;

/* Objective 2 */

/* Find the vehicle types that are most often and least often stolen */
Select vehicle_type, (COUNT(vehicle_id)) AS Stolen
from stolen_vehicles
group by vehicle_type
order by Stolen DESC
LIMIT 1;

/* For each vehicle type, find the average age of the cars that are stolen */
Select vehicle_type, (COUNT(vehicle_id)) AS Stolen
from stolen_vehicles
group by vehicle_type
order by Stolen ASC
LIMIT 1;

Select vehicle_type, AVG(Year(date_stolen) - model_year)AS Avg_Car_Age
from stolen_vehicles
group by vehicle_type
order by Avg_Car_Age DESC;

/* For each vehicle type, find the percent of vehicles stolen that are luxury versus standard */
With Luxury_Standard AS (select sv.vehicle_type, CASE when md.make_type = 'Luxury' THEN 1 ELSE 0 END AS Luxury, 1 AS All_Cars
from stolen_vehicles as sv
LEFT JOIN  make_details as md
ON  sv.make_id = md.make_id)

SELECT vehicle_type, (SUM(Luxury)/SUM(All_Cars))*100 AS Percentage_of_Luxury
FROM Luxury_Standard
group by vehicle_type
order by Percentage_of_Luxury DESC;

/* Create a table where the rows represent the top 10 vehicle types, 
						the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and 
                        the values are the number of vehicles stolen */
                        
select color, COUNT(vehicle_id) AS num_vehicles
from stolen_vehicles
Group by color
order by num_vehicles DESC
LIMIT 7;

select vehicle_type, COUNT(vehicle_id) AS num_vehicles,
		SUM(CASE WHEN color = 'Silver' THEN 1 ELSE 0 END) AS 'Silver',
        SUM(CASE WHEN color = 'White' THEN 1 ELSE 0 END) AS 'White',
        SUM(CASE WHEN color = 'Black' THEN 1 ELSE 0 END) AS 'Black',
        SUM(CASE WHEN color = 'Blue' THEN 1 ELSE 0 END) AS 'Blue',
        SUM(CASE WHEN color = 'Red' THEN 1 ELSE 0 END) AS 'Red',
        SUM(CASE WHEN color = 'Grey' THEN 1 ELSE 0 END) AS 'Grey',
        SUM(CASE WHEN color = 'Green' THEN 1 ELSE 0 END) AS 'Green',
        SUM(CASE WHEN color IN ('Gold','Brown','Yellow','Orange','Purple','Cream Pink') THEN 1 ELSE 0 END) AS 'Other'
from stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 10;

/* Objective 3 */

/* Find the number of vehicles that were stolen in each region */

select l.region, count(sv.vehicle_id) AS No_of_vehicles
from stolen_vehicles as sv 
LEFT JOIN  locations as l 
ON  sv.location_id = l.location_id
group by l.region
order by No_of_vehicles DESC;

/* Combine the previous output with the population and density statistics for each region */

select l.region, count(sv.vehicle_id) AS No_of_vehicles, l.population, l.density
from stolen_vehicles as sv 
LEFT JOIN  locations as l 
ON  sv.location_id = l.location_id
group by l.region, l.population, l.density
order by No_of_vehicles DESC;

/* Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions? */

select l.region, count(sv.vehicle_id) AS No_of_vehicles, l.population, l.density
from stolen_vehicles as sv 
LEFT JOIN  locations as l 
ON  sv.location_id = l.location_id
group by l.region, l.population, l.density
order by l.density DESC;

'Auckland', 'Nelson','Wellington'
'Otago','Gisborne','Southland'

(select 'High Density',  sv.vehicle_type, count(sv.vehicle_id) AS No_of_vehicles
from stolen_vehicles as sv 
LEFT JOIN  locations as l 
ON  sv.location_id = l.location_id
WHERE l.region IN ('Auckland', 'Nelson','Wellington')
group by sv.vehicle_type
order by No_of_vehicles DESC
limit 5)
UNION
(select 'Low Density', sv.vehicle_type, count(sv.vehicle_id) AS No_of_vehicles
from stolen_vehicles as sv 
LEFT JOIN  locations as l 
ON  sv.location_id = l.location_id
WHERE l.region IN ('Otago','Gisborne','Southland')
group by sv.vehicle_type
order by No_of_vehicles DESC
limit 5);