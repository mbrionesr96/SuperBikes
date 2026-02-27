CREATE TABLE users( --1-N to payments; 1-N to subscriptions; 1-N to rides
  user_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email_id VARCHAR(100) UNIQUE NOT NULL,
 -- dob DATE NOT NULL, --what's this variable?
  reg_date DATE --registered date.
);

CREATE TABLE stations( --1-N to bikes
  station_id INT PRIMARY KEY,
  station_name VARCHAR(50) NOT NULL UNIQUE,
  capacity INT NOT NULL
);

CREATE TABLE bikes( --1-N to rides;  N-1 to stations; 1-N to maintenances
  bike_id INT PRIMARY KEY,
  bike_type TEXT CHECK (bike_type IN ('manual', 'electric')) NOT NULL,
  bike_status TEXT CHECK (bike_status IN ('docked','in use','under maintenance')), --status seemed to be a function, also shared with status on maintenances
  current_station_id INT, --N-1 to stations
  battery_level FLOAT,
  -- purchase_date DATE,
  CHECK (battery_level>=20),
  CONSTRAINT fk_current_station_id FOREIGN KEY (current_station_id) REFERENCES stations(station_id) --definition of FK 
);

CREATE TABLE rides(
  ride_id INT PRIMARY KEY,
  user_id INT, --N-1 to users
  bike_id INT, --N-1 to bikes
  from_station INT REFERENCES stations(station_id), --check foreign key is this  1 to M?
  to_station INT REFERENCES stations(station_id), --check foreign key is this  1 to M?
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  ride_cost FLOAT NOT NULL,
  ride_status TEXT CHECK (ride_status IN ('ongoing','completed')) NOT NULL,
  ride_dist_km FLOAT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id), --definition of FK
  FOREIGN KEY (bike_id) REFERENCES bikes(bike_id) --definition of FK
);

CREATE TABLE maintenances(
  maint_id INT PRIMARY KEY,
  bike_id INT, --N-1 to bikes
  issue TEXT,
  reported_date DATE NOT NULL,
  fixed_date DATE NOT NULL,
  maint_status TEXT CHECK (maint_status IN ('ongoing','done')), --status seemed to be a function, also shared with status on bikes
  FOREIGN KEY (bike_id) REFERENCES bikes(bike_id) --definition of FK
  );

CREATE TABLE subscriptions(
  sub_id INT PRIMARY KEY,
  user_id INT, --N-1 to users,
  cost NUMERIC (6,2) NOT NULL, 
  sub_type TEXT CHECK (sub_type IN ('monthly','yearly','quarterly')),
  begining_date DATE NOT NULL, --start_date seems to be a function? 
  end_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) --definition of FK
);

CREATE TABLE payments(
  payment_id INT PRIMARY KEY,
  user_id INT, --N-1 to users
  ride_id INT REFERENCES rides(ride_id), --strange foreign key
  amount FLOAT NOT NULL,
  payment_date DATE NOT NULL,
  payment_status TEXT CHECK (payment_status IN ('success','failed')),
  FOREIGN KEY (user_id) REFERENCES users(user_id) --definition of FK
);
