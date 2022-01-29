-- 1--
SELECT * FROM state_climate
LIMIT 5;

-- 2--Write a query that returns the state, year, tempf or tempc, and running_avg_temp (in either Celsius or Fahrenheit) for each state.
SELECT state, year, tempf,
  AVG(tempf) OVER
  (PARTITION BY state
  ORDER BY year) AS running_avg_temp
FROM state_climate
LIMIT 5;

-- 3--Write a query that returns state, year, tempf or tempc, and the lowest temperature (lowest_temp) for each state.
SELECT state, year, tempf,
  FIRST_VALUE(tempf) OVER (
  PARTITION BY state
  ORDER BY tempf
  ) AS lowest_temp
FROM state_climate
LIMIT 5;

-- 4--write a query that returns state, year, tempf or tempc, except now we will also return the highest temperature (highest_temp) for each state.
SELECT state, year, tempf,
  LAST_VALUE(tempf) OVER (
  PARTITION BY state
  ORDER BY tempf
  RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS highest_temp
FROM state_climate
LIMIT 5;

-- 5--Write a query to select the same columns but now you should write a window function that returns the change_in_temp from the previous year
SELECT state, year, tempf,
  tempf - LAG(tempf, 1, tempf) OVER
  (PARTITION BY state
  ORDER BY year) AS change_in_temp
FROM state_climate
ORDER BY change_in_temp DESC
LIMIT 5;

-- 6--Write a query to return a rank of the coldest temperatures on record 
SELECT RANK() OVER (ORDER BY tempf ASC)
AS coldest_rank,
  year, state, tempf
FROM state_climate
LIMIT 10;

-- 7--Modify your coldest_rank query to now instead return the warmest_rank for each state
SELECT RANK() OVER(
  PARTITION BY state
  ORDER BY tempf DESC)
AS warmest_rank,
  year, state, tempf
FROM state_climate
LIMIT 10;

-- 8--write a query that will return the average yearly temperatures in quartiles instead of in rankings for each state
SELECT NTILE(4) OVER(
  PARTITION BY state
  ORDER BY tempf ASC) AS quartile,
  year, state, tempf
FROM state_climate
LIMIT 5;

-- 9--Lastly, we will write a query that will return the average yearly temperatures in quintiles (5). The top quintile should be the coldest years overall, not by state.

SELECT NTILE(5) OVER(
  ORDER BY tempf ASC) AS quintile,
  year, state, tempf
FROM state_climate
LIMIT 5;
