-- cleaner DDL
CREATE TABLE users( --1-N to payments; 1-N to subscriptions; 1-N to rides
  user_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email_id VARCHAR(100) UNIQUE NOT NULL,
  reg_date DATE --registered date.
);

CREATE TABLE stations( --1-N to bikes, 1-N to ridesx2
  station_id INT PRIMARY KEY,
  station_name VARCHAR(50) NOT NULL UNIQUE,
  capacity INT NOT NULL
);

CREATE TABLE bikes( --1-N to rides;  N-1 to stations; 1-N to maintenances
  bike_id INT PRIMARY KEY,
  bike_type TEXT CHECK (bike_type IN ('manual', 'electric')) NOT NULL,
  bike_status TEXT CHECK (bike_status IN ('docked','in use','under maintenance')), 
  current_station_id INT, --N-1 to stations
  battery_level FLOAT,
  -- Battery logic depending on bike type
  CHECK ((bike_type = 'manual' AND battery_level IS NULL) OR
         (bike_type = 'electric' AND battery_level BETWEEN 0 AND 100)),
  -- Maintenance rule
  CHECK(battery_level > 20 OR bike_status = 'under maintenance'),
  CONSTRAINT fk_current_station_id FOREIGN KEY (current_station_id) REFERENCES stations(station_id)--definition of FK 
  ON DELETE CASCADE 
);

CREATE TABLE rides(
  ride_id INT PRIMARY KEY,
  user_id INT, --N-1 to users
  bike_id INT, --N-1 to bikes
  from_station INT REFERENCES stations(station_id), --1-N to stations
  to_station INT REFERENCES stations(station_id), --1-N to stations
  start_time TIME NOT NULL,
  end_time TIME,
  ride_cost FLOAT CHECK (ride_cost >= 0),
  ride_status TEXT CHECK (ride_status IN ('ongoing','completed')) NOT NULL,
  ride_dist_km FLOAT,
  FOREIGN KEY (user_id) REFERENCES users(user_id), --definition of FK
  FOREIGN KEY (bike_id) REFERENCES bikes(bike_id) --definition of FK
  ON DELETE CASCADE 
);

CREATE TABLE maintenances(
  maint_id INT PRIMARY KEY,
  bike_id INT, --N-1 to bikes
  issue TEXT,
  reported_date DATE NOT NULL,
  fixed_date DATE,
  maint_status TEXT CHECK (maint_status IN ('ongoing','done')), 
  FOREIGN KEY (bike_id) REFERENCES bikes(bike_id) --definition of FK
  ON DELETE CASCADE 
  );

CREATE TABLE subscriptions(
  sub_id INT PRIMARY KEY,
  user_id INT, --N-1 to users,
  cost NUMERIC (6,2) NOT NULL, 
  sub_type TEXT CHECK (sub_type IN ('monthly','yearly','quarterly')),
  begining_date DATE NOT NULL, 
  end_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) --definition of FK
  ON DELETE CASCADE 
);

CREATE TABLE payments(
  payment_id INT PRIMARY KEY,
  user_id INT, --N-1 to users
  ride_id INT REFERENCES rides(ride_id),
  amount FLOAT NOT NULL,
  payment_date DATE NOT NULL,
  payment_status TEXT CHECK (payment_status IN ('success','failed')),
  FOREIGN KEY (user_id) REFERENCES users(user_id) --definition of FK
  ON DELETE CASCADE 
);