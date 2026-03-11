-- 1. Station Popularity: A list of the top 5 stations where rides most frequently start.
SELECT
      s.station_id,
      s.station_name,
      count(r.ride_id) AS rides_started
FROM stations s 
LEFT JOIN rides r
  ON r.from_station=s.station_id
GROUP BY s.station_id,s.station_name
ORDER BY rides_started DESC, s.station_name
LIMIT 5;

-- 2. Revenue Analysis: Calculate the total monthly revenue grouped by membership type (e.g., "Pay-as-you-go" vs. "Monthly Subscriber").
SELECT 
    TO_CHAR(DATE_TRUNC('month', beginning_date), 'YYYY-MM') AS month,
    sub_type AS subscription_type,
    SUM(cost) AS total_income
FROM subscriptions
GROUP BY subscription_type, month
    UNION ALL -- combines data from subscriptions (above) to payments (below)
SELECT 
    TO_CHAR(DATE_TRUNC('month', payment_date), 'YYYY-MM') AS month,
    'pay as-you-go' AS subscription_type,
    SUM(amount) AS total_income
FROM payments
WHERE ride_id > 0 --This is were our data migh get redundant as many rows on payments do not correspond to rides but to subscriptions
GROUP BY month
ORDER BY month, subscription_type;

-- 3. Maintenance Alert: A query using a JOIN to find all Electric Bikes with a battery level below 20% that are currently docked.
SELECT
  b.bike_id,
  b.bike_type,
  b.battery_level,
  b.bike_status,
  b.current_station_id,
  s.station_name
FROM bikes b
JOIN stations s
  ON b.current_station_id = s.station_id
WHERE lower(b.bike_type) = 'electric'
  AND lower(b.bike_status) = 'docked'
  AND b.battery_level < 20;

-- 4. User Behavior: Find users who have ridden more than the average distance, sorted by ridden distance.
SELECT
    rides.user_id,
    COUNT(rides.user_id) AS "number of rides",
    users.first_name,
    SUM(ride_dist_km) AS total_distance,
    AVG(ride_dist_km) AS mean_distance
FROM rides
JOIN users
    ON rides.user_id = users.user_id
GROUP BY rides.user_id, users.first_name
HAVING AVG(ride_dist_km) >= (
    SELECT AVG(ride_dist_km)
    FROM rides
)
ORDER BY total_distance DESC;

--Check average distance
SELECT AVG(ride_dist_km) FROM rides;