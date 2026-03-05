-- Station Popularity: A list of the top 5 stations where rides most frequently start.

---------Sayatan's code

--Revenue Analysis: Calculate the total monthly revenue grouped by membership type (e.g., "Pay-as-you-go" vs. "Monthly Subscriber").
SELECT 
    TO_CHAR(DATE_TRUNC('month', beginning_date), 'YYYY-MM') AS month,
    sub_type AS subscription_type,
    SUM(cost) AS total_income
FROM subscriptions
GROUP BY subscription_type, month

UNION ALL

SELECT 
    TO_CHAR(DATE_TRUNC('month', payment_date), 'YYYY-MM') AS month,
    'Pay as-you-go' AS subscription_type,
    SUM(amount) AS total_income
FROM payments
WHERE ride_id > 0 --This is were our data migh get redundant as many rows on payments do not correspond to rides but to subscriptions
GROUP BY month

ORDER BY month, subscription_type;

--Maintenance Alert: A query using a JOIN to find all Electric Bikes with a battery level below 20% that are currently docked.

--User Behavior: Find users who have ridden more than the average distance, sorted by ridden distance.
SELECT
    user_id,
    SUM(ride_dist_km) AS total_distance--,
    --AVG(ride_dist_km) AS mean_distance
FROM rides
GROUP BY user_id
HAVING AVG(ride_dist_km) >= ( --we didn't see this statement at class, god bless stackoverflow
    SELECT AVG(ride_dist_km)
    FROM rides
)
ORDER BY total_distance;