--Create Tables 

--drop table users281;
--drop table user_foods;
--drop table nutrition;

CREATE TABLE `users281` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(65),
  `email` varchar(65) NOT NULL,
  `age` int(11),
  `gender` bit(1),
  `password` varchar(65) NOT NULL DEFAULT '',
  `token` varchar(65) NOT NULL DEFAULT '',
  `token_expire_at` timestamp NOT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) DEFAULT CHARSET=utf8;

CREATE TABLE `user_foods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `food_id` varchar(11) NOT NULL,
  `food_name` varchar(50) DEFAULT NULL,
  `meal_id` int(2) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL,
  `amazon_userId` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE `nutrition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usda_food_id` int(11) NOT NULL,
  `food_name` varchar(50) NOT NULL,
  `measure` int(10) NOT NULL DEFAULT 1, -- our default is 100g, but it could extend to Cup=225 gms etc.
  `energy` int(10) NOT NULL,
  `carb` decimal(5,3) NOT NULL,
  `protein` decimal(5,3) NOT NULL,
  `fat` decimal(5,3) NOT NULL, -- column Total lipid (fat) from USDA Table
  `water` decimal(5,3) NOT NULL,
  `sugar` decimal(5,3)  NOT NULL,
  `fiber` decimal(5,3) NOT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE `measurements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `measure_value` decimal(5,3) NOT NULL,
  `measure_type` varchar(10) NOT NULL,
  `measured_at` timestamp NOT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


--Sample Data
INSERT INTO users281(name, email,age,gender,password, token, token_expire_at, created_at) 
VALUES ('test','nutracker.test@gmail.com',30,1,'testo123!','','2018-01-01 00:00:00',Now()); 

--- One day nutrition for an adult
INSERT INTO user_foods(user_id, food_id, food_name, meal_id,count, created_at) 
VALUES (1,1,'banana',1,1,Now()); 

INSERT INTO user_foods(user_id, food_id, food_name, meal_id,count, created_at) 
VALUES (1,2,'Milk',1,2,Now()); 

INSERT INTO user_foods(user_id, food_id, food_name, meal_id,count, created_at) 
VALUES (1,3,'rice',2,2,Now()); 

INSERT INTO user_foods(user_id, food_id, food_name, meal_id,count, created_at) 
VALUES (1,4,'Egg',3,1,Now()); 

INSERT INTO user_foods(user_id, food_id, food_name, meal_id,count, created_at) 
VALUES (1,5,'PASTA SALAD',4,2,Now()); 

-- Corresponding to user foods, entries into nutrition table
INSERT INTO nutrition(usda_food_id, food_name, measure, energy, carb, protein, fat, water, sugar, fiber, created_at)
VALUES (09040, 'banana', 1, 89, 22.84, 1.09, 0.217, 74.91, 12.23, 2.6, Now());

INSERT INTO nutrition(usda_food_id, food_name, measure, energy, carb, protein, fat, water, sugar, fiber, created_at)
VALUES (01077, 'milk', 1, 61, 4.80, 3.15, 2.872, 88.13, 5.05, 0.0, Now());

INSERT INTO nutrition(usda_food_id, food_name, measure, energy, carb, protein, fat, water, sugar, fiber, created_at)
VALUES (20450, 'rice', 1, 360, 79.34, 6.61, 0.49, 12.89, 0.0, 0.0, Now());

INSERT INTO nutrition(usda_food_id, food_name, measure, energy, carb, protein, fat, water, sugar, fiber, created_at)
VALUES (01123, 'egg', 1, 143, 0.72, 12.56, 8.567, 76.15, 0.37, 0.0, Now());

INSERT INTO nutrition(usda_food_id, food_name, measure, energy, carb, protein, fat, water, sugar, fiber, created_at)
VALUES (45040488, 'PASTA SALAD', 1, 340, 68.09, 12.77, 0.0, 0.0, 4.26, 4.3, Now());

