-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: ship_database
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `buying_log`
--

DROP TABLE IF EXISTS `buying_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buying_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address` text,
  `ship_name` varchar(255) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `purchase_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buying_log`
--

LOCK TABLES `buying_log` WRITE;
/*!40000 ALTER TABLE `buying_log` DISABLE KEYS */;
INSERT INTO `buying_log` VALUES (1,'Adjkgads','a@gmail.com','84357634869834','bbbb','Ferretti Custom Line 97',12750000.00,'2024-12-31 10:34:10'),(2,'Artun Cankar','art@gmail.com','054423847136891','aaaaaa','Ferretti Custom Line 97',12750000.00,'2024-12-31 10:10:17'),(3,'Damla Cankar','dam@gmail.com','5554789763','fndsjbjsdbjadbjdas','Mangusta 105 2023',5500000.00,'2025-01-16 01:00:05'),(4,'Damla Cankar','dam@gmail.com','05436789543','sjdhfjdnskcnsk','Harbor Queen',25000.00,'2025-01-15 23:38:14'),(5,'Halil Musa','hm@gmail.com','5554443789','jfsdhbldsjjcsd','Titanic',1000000.00,'2025-01-16 14:07:42');
/*!40000 ALTER TABLE `buying_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rental_ships`
--

DROP TABLE IF EXISTS `rental_ships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rental_ships` (
  `ship_name` varchar(255) NOT NULL,
  `ship_type` varchar(100) NOT NULL,
  `ship_length` int NOT NULL,
  `ship_width` int NOT NULL,
  `rental_price_per_day` int NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `seller` varchar(45) NOT NULL,
  `user_rating` float DEFAULT '0',
  PRIMARY KEY (`ship_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rental_ships`
--

LOCK TABLES `rental_ships` WRITE;
/*!40000 ALTER TABLE `rental_ships` DISABLE KEYS */;
INSERT INTO `rental_ships` VALUES ('Blue Wave','Fishing',26,6,800,'https://static.vesselfinder.net/ship-photo/9453377-209722000-3a90e9e7e02f5075f1a8ece52db76eac/1?v1','Fishermen\'s Paradise',4.6),('Harbor Queen','Cruise',300,35,25000,'https://s3-media0.fl.yelpcdn.com/bphoto/RP_CUW0jUD3CVPaeEH8ttw/348s.jpg','Oceanic Travels',1.8),('Ocean Explorer','Cargo',200,32,12000,'https://static.vesselfinder.net/ship-photo/9883194-311000869-c5877b321d3d1174ce97f548721e8ab1/1?v1','Global Shipping Co.',1.8),('Sea Voyager','Yacht',41,8,1500,'https://static.vesselfinder.net/ship-photo/9799707-371581000-f14d323c8456592332dda549aa1f443a/1?v1','Luxury Boats Ltd.',2.9),('Wind Rider','Sailing',15,4,500,'https://static.vesselfinder.net/ship-photo/9965045-416947000-afef8ac6ae0bae7bd8b03ce2464debb7/1?v1','Sailors United',4);
/*!40000 ALTER TABLE `rental_ships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `renting_log`
--

DROP TABLE IF EXISTS `renting_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `renting_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address` text,
  `ship_name` varchar(255) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `purchase_date` datetime DEFAULT NULL,
  `rental_start_date` date DEFAULT NULL,
  `rental_end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `renting_log`
--

LOCK TABLES `renting_log` WRITE;
/*!40000 ALTER TABLE `renting_log` DISABLE KEYS */;
INSERT INTO `renting_log` VALUES (1,'Artun Cankar','art@gmail.com','055543322442','aaaaaa','Blue Wave',800.00,'2024-12-31 10:11:36',NULL,NULL),(2,'Damla Cankar','dam@gmail.com','05334710345','fjfnvjnsdjnsşlkhdjb','Blue Wave',800.00,'2025-01-16 01:21:17',NULL,NULL),(3,'Hakkı fırat','h@gmail.com','54436789012','hjkfbljks','Harbor Queen',375000.00,'2025-01-16 14:06:17','2025-01-16','2025-01-31');
/*!40000 ALTER TABLE `renting_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `selling_ships`
--

DROP TABLE IF EXISTS `selling_ships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selling_ships` (
  `ship_name` varchar(255) NOT NULL,
  `ship_length` varchar(50) NOT NULL,
  `ship_type` varchar(50) NOT NULL,
  `seller` varchar(255) NOT NULL,
  `selling_price` int NOT NULL,
  `ship_width` varchar(50) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `user_rating` float DEFAULT '0',
  PRIMARY KEY (`ship_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `selling_ships`
--

LOCK TABLES `selling_ships` WRITE;
/*!40000 ALTER TABLE `selling_ships` DISABLE KEYS */;
INSERT INTO `selling_ships` VALUES ('Ferretti Custom Line 97','29.7','Motoryacht','Can D.',12750000,'7.0','https://images.boats.com/resize/1/59/63/8155963_20211210065914967_1_XLARGE.jpg?t=1639148308000',4.9),('Leopard 53 Powercat 2021','15.4','Power Katamaran','Sinan Malkoç',72000000,'7.67','https://images.boatsgroup.com/resize/1/20/91/8372091_20220627054514998_1_XLARGE.jpg?w=400&h=267&t=1656333958000&exact&format=webp',3.9),('Mangusta 105 2023','32.5','Motoryacht','Meric Y.',5500000,'6.0','https://image.yachtbuyer.com/w933/h700/q90/ca/ke5c96754/model/photo/644272.jpg',3.7),('Queen Mary','305.0','Cargo','Atlantic Co.',2000000,'30.5','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4mh8jZk01_YTaHaHmN-roBM38o3sRLnzK8w&s',1.9),('Titanic','269.1','Cruise','Oceanic Inc.',1000000,'28.2','https://www.worldhistory.org/uploads/images/14047.png',1.5);
/*!40000 ALTER TABLE `selling_ships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ship_comments`
--

DROP TABLE IF EXISTS `ship_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ship_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ship_id` int NOT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ship_comments`
--

LOCK TABLES `ship_comments` WRITE;
/*!40000 ALTER TABLE `ship_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ship_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `secret_question` varchar(100) DEFAULT NULL,
  `secret_answer` varchar(255) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user@gmail.com','pasaword','1','Dog',0),(2,'art@gmail.com','pwd','2','Cat',1),(3,'dam@gmail.com','pwdddd','1','Red',0),(4,'ffff@gmail.com','121212kk','3','Barbaros',0),(5,'murat@gmail.com','110pwd','5','Antalya',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-17  0:31:26
