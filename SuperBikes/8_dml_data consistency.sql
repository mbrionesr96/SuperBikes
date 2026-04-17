-- capacity sum against count of bikes
SELECT
    (SELECT SUM(capacity) FROM stations) AS total_capacity,
    (SELECT COUNT(*) FROM bikes) AS total_bikes;

-- capacity of each station against docked bikes
SELECT 
    s.station_id,
    s.station_name,
    s.capacity,
    COUNT(b.bike_id) AS docked_bikes
FROM stations s
LEFT JOIN bikes b 
    ON s.station_id = b.current_station_id
    AND b.bike_status = 'docked'
GROUP BY 
    s.station_id, 
    s.station_name, 
    s.capacity
ORDER BY s.station_id;

-- bikes with less than 20% 
SELECT COUNT(*) as nr_lb_bikes
 FROM bikes
 WHERE battery_level <= 20;

-- N° of payments and subscriptions
SELECT 
    (SELECT COUNT(*) FROM payments) AS payments_count,
    (SELECT COUNT(*) FROM subscriptions) AS subscriptions_count;