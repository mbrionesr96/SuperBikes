-- DDL of Super Group DB
-- List of entities (creator) and relationships
--    - users (Riccardo) 1-N to payments; 1-N to subscriptions; 1-N to rides
--    - payments (Riccardo) N-1 to users
--    - subscriptions (Riccardo) N-1 to users
--    - rides (Maria) N-1 to bikes; 
--    - maintenances (Maria) N-1 to bikes
--    - bikes (Sayatan) 1-N to rides;  N-1 to stations; 1-N to maintenances
--    - stations (Sayatan) 1-N to bikes

-- DO NOT FORGET: 
--    - Normalize your tables to at least Third Normal Form (3NF)
--    - Data types (e.g., VARCHAR, TIMESTAMP, DECIMAL).
--    - Integrity constraints (NOT NULL, UNIQUE, CHECK constraints for bike battery levels).
--    - Foreign Keys and Foreigh Keys actions (ON DELETE CASCADE, etc.)

 