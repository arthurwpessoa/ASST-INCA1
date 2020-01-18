-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: zerowaste
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_number` char(16) DEFAULT NULL,
  `expiring_date` char(5) DEFAULT NULL,
  `cvc` char(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
INSERT INTO `cards` VALUES (1,'378282246310005','12/25','756');
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `ingredients` varchar(1024) NOT NULL,
  `price` double NOT NULL,
  `photo` longblob,
  `allergies` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'Fat Tuesday Salad','2019-12-02','New Orleans style hot sliced Cajun chicken breast with mixed greens, tomatoes, cucumbers and hard-cooked eggs with warm, spicy honey mustard dressing topped with crumbled bacon..\n',17.95,_binary 'http://localhost/zerowaste/assets/img/menu/salad.jpg','Cereals containing gluten, Milk (including lactose)'),(2,'Maccheroni with tomatoes and seafood','2019-11-16','Macaroni, tomato, olive oil, garlic, lemon, barramundi, molluscs',13.95,_binary 'http://localhost/zerowaste/assets/img/menu/maccaroni.jpg','Crustaceans, Molluscs and Lupin'),(3,'Beef steak with rocket salad and parmesan','2019-11-16','Beef, Lettuce, parmesan cheese',13.95,_binary 'http://localhost/zerowaste/assets/img/menu/steaksalad.jpg','Cereals containing gluten, Milk (including lactose)'),(4,'Stuffed Jumbo Shrimp','2019-11-16','Crabmeat, chopped scallops, mushrooms, Jack cheese, seasoned bread crumbs, white wine and butter stuffing.',12.95,_binary 'http://localhost/zerowaste/assets/img/menu/crab-stuffed-jumbo-shrimp.jpg','Crustaceans, Molluscs and Lupin'),(5,'Chicken Scampi Roja','2019-11-16','Boneless chicken breast sautéed in a scampi sauce with sun-dried tomatoes, artichoke hearts, and spinach. Tossed with linguini and finished with roasted red pepper pesto and the chef’s choice of ravioli',19.95,_binary 'http://localhost/zerowaste/assets/img/menu/scampi-square.jpg',''),(6,'Beef Burguer','2020-01-18','Lettuce',3,'','none');
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_id` int(11) NOT NULL,
  `person_id` int(11) DEFAULT NULL,
  `date` date NOT NULL,
  `quantity` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `person_id` (`person_id`),
  KEY `menu_id` (`menu_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,3,1,'2019-12-30',1),(2,1,1,'2019-12-30',1),(3,4,1,'2019-12-30',1),(4,3,1,'2019-12-30',1),(5,3,1,'2019-12-30',1),(6,5,1,'2019-12-30',1),(7,4,1,'2019-12-30',1),(8,4,1,'2019-12-30',1),(9,1,1,'2019-12-30',1),(10,1,1,'2019-12-30',1),(11,1,1,'2019-12-30',1),(12,1,1,'2019-12-30',1),(13,1,1,'2019-12-30',1),(14,1,1,'2019-12-30',1),(15,1,1,'2019-12-30',1),(16,1,1,'2019-12-30',1),(17,1,1,'2019-12-30',1),(18,1,1,'2019-12-30',1),(19,1,1,'2019-12-30',1),(20,1,1,'2019-12-30',1),(21,1,1,'2019-12-30',1),(22,1,1,'2019-12-30',1),(23,1,1,'2019-12-30',1),(24,1,1,'2019-12-30',1),(25,1,1,'2019-12-30',1),(26,1,1,'2019-12-30',1),(27,5,1,'2020-01-02',1),(28,5,1,'2020-01-02',1),(29,5,1,'2020-01-02',1),(30,5,1,'2020-01-02',1),(31,5,1,'2020-01-02',1),(32,5,1,'2020-01-02',1),(33,5,1,'2020-01-02',1),(34,5,1,'2020-01-02',1),(35,5,1,'2020-01-02',1),(36,5,1,'2020-01-02',1),(37,5,1,'2020-01-02',1),(38,5,1,'2020-01-02',1),(39,5,1,'2020-01-02',1),(40,5,1,'2020-01-02',1),(41,5,1,'2020-01-02',1),(42,5,1,'2020-01-02',1),(43,5,1,'2020-01-02',1),(44,3,1,'2020-01-02',1),(45,5,1,'2020-01-02',1),(46,3,1,'2020-01-02',1),(47,3,1,'2020-01-02',1),(48,1,1,'2020-01-02',1),(49,2,1,'2020-01-02',1),(50,3,1,'2020-01-02',1),(51,1,1,'2020-01-02',1),(52,1,1,'2020-01-02',1),(53,2,1,'2020-01-02',1),(54,5,1,'2020-01-02',1),(55,5,1,'2020-01-02',1),(56,5,1,'2020-01-02',1),(57,5,1,'2020-01-02',1),(58,5,1,'2020-01-02',1),(59,5,1,'2020-01-02',1),(60,1,1,'2020-01-03',1),(61,1,1,'2020-01-03',1),(62,1,1,'2020-01-03',1),(63,4,1,'2020-01-13',1),(64,4,1,'2020-01-13',1),(65,4,1,'2020-01-13',1),(66,4,1,'2020-01-13',1),(67,6,1,'2020-01-18',1),(68,6,1,'2020-01-18',1),(69,6,1,'2020-01-18',1),(70,6,1,'2020-01-18',1),(71,6,1,'2020-01-18',1),(72,6,1,'2020-01-18',1),(73,6,1,'2020-01-18',1),(74,6,1,'2020-01-18',1),(75,6,1,'2020-01-18',1),(76,6,1,'2020-01-18',1),(77,6,1,'2020-01-18',1),(78,6,1,'2020-01-18',1),(79,6,1,'2020-01-18',1),(80,6,1,'2020-01-18',1),(81,6,1,'2020-01-18',1),(82,6,1,'2020-01-18',1),(83,6,1,'2020-01-18',1),(84,6,1,'2020-01-18',1),(85,6,1,'2020-01-18',1),(86,6,1,'2020-01-18',1),(87,6,1,'2020-01-18',1),(88,6,1,'2020-01-18',1),(89,6,1,'2020-01-18',1),(90,6,1,'2020-01-18',1),(91,6,1,'2020-01-18',1),(92,6,1,'2020-01-18',1),(93,6,1,'2020-01-18',1),(94,6,1,'2020-01-18',1),(95,6,1,'2020-01-18',1),(96,6,1,'2020-01-18',1),(97,6,1,'2020-01-18',1),(98,6,1,'2020-01-18',1),(99,6,1,'2020-01-18',1),(100,6,1,'2020-01-18',1),(101,6,1,'2020-01-18',1),(102,6,1,'2020-01-18',1),(103,6,1,'2020-01-18',1),(104,6,1,'2020-01-18',1),(105,6,1,'2020-01-18',1),(106,6,1,'2020-01-18',1),(107,6,1,'2020-01-18',1),(108,6,1,'2020-01-18',1),(109,6,1,'2020-01-18',1),(110,6,1,'2020-01-18',1),(111,6,1,'2020-01-18',1),(112,6,1,'2020-01-18',1);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `credit` double NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,12,'2019-12-15 16:17:47'),(2,1,12,'2019-12-15 16:18:03'),(3,1,12,'2019-12-15 16:18:12'),(4,1,12,'2019-12-15 16:18:20'),(5,1,12,'2019-12-15 16:18:46'),(6,1,12,'2019-12-15 16:19:03'),(7,1,12,'2019-12-15 16:19:38'),(8,1,12,'2019-12-15 16:19:47'),(9,1,12,'2019-12-15 16:20:03'),(10,1,12,'2019-12-15 16:20:20'),(11,1,12,'2019-12-15 16:20:27'),(12,1,12,'2019-12-20 01:01:09'),(13,1,12,'2019-12-20 01:01:18'),(14,1,12,'2019-12-20 01:02:04'),(15,1,12,'2019-12-20 01:03:20'),(16,1,12,'2019-12-20 01:03:32'),(17,1,12,'2019-12-20 01:04:18'),(18,1,12,'2019-12-20 01:04:44'),(19,1,12,'2019-12-20 01:05:15'),(20,1,12,'2019-12-20 01:05:21'),(21,1,15,'2019-12-20 01:12:27'),(22,1,15,'2019-12-20 01:17:49'),(23,1,15,'2019-12-20 01:18:26'),(24,1,15,'2019-12-20 01:18:50'),(25,1,15,'2019-12-20 01:20:15'),(26,1,27,'2019-12-20 01:25:20'),(27,1,15,'2019-12-20 01:28:21'),(28,1,15,'2019-12-20 08:34:20'),(29,1,15,'2019-12-20 08:57:40'),(30,1,15,'2019-12-20 09:00:03'),(31,1,15,'2019-12-24 18:31:53'),(32,1,15,'2019-12-24 18:31:57'),(33,1,15,'2019-12-24 18:32:51'),(34,1,15,'2019-12-24 18:33:56'),(35,1,15,'2019-12-29 23:46:46'),(36,1,15,'2019-12-29 23:59:07'),(37,1,15,'2019-12-30 00:01:20'),(38,1,15,'2019-12-30 00:01:42'),(39,1,15,'2019-12-30 07:09:56'),(40,1,15,'2019-12-30 15:10:08'),(41,1,15,'2019-12-30 15:12:00'),(42,1,15,'2019-12-30 15:17:53'),(43,1,15,'2019-12-30 15:21:34'),(44,1,15,'2019-12-30 15:22:28'),(45,1,15,'2019-12-30 15:22:29'),(46,1,15,'2019-12-30 15:22:32'),(47,1,15,'2019-12-30 15:23:08'),(48,1,15,'2019-12-30 15:27:47'),(49,1,15,'2019-12-30 15:32:15'),(50,1,15,'2019-12-30 15:32:25'),(51,1,15,'2019-12-30 15:33:31'),(52,1,15,'2019-12-30 15:33:41'),(53,1,20,'2019-12-30 15:34:09'),(54,1,15,'2020-01-02 14:40:34'),(55,1,15,'2020-01-02 14:41:15'),(56,1,15,'2020-01-02 14:41:30'),(57,1,15,'2020-01-02 14:43:43'),(58,1,15,'2020-01-02 14:46:29'),(59,1,15,'2020-01-02 14:48:51'),(60,1,15,'2020-01-02 14:49:36'),(61,1,15,'2020-01-02 14:50:05'),(62,1,15,'2020-01-02 14:51:30'),(63,1,15,'2020-01-02 14:58:18'),(64,1,15,'2020-01-02 15:01:19'),(65,1,15,'2020-01-02 15:02:14'),(66,1,15,'2020-01-02 15:12:37'),(67,1,17,'2020-01-02 15:16:18'),(68,1,19,'2020-01-02 15:30:45'),(69,1,30,'2020-01-02 15:31:41'),(70,1,15,'2020-01-02 15:40:01'),(71,1,15,'2020-01-02 15:58:12'),(72,1,15,'2020-01-02 15:59:15'),(73,1,15,'2020-01-02 15:59:32'),(74,1,15,'2020-01-02 16:00:06'),(75,1,15,'2020-01-02 16:00:38'),(76,1,15,'2020-01-02 16:00:47'),(77,1,15,'2020-01-02 16:01:16'),(78,1,15,'2020-01-02 16:01:27'),(79,1,15,'2020-01-02 16:36:37'),(80,1,15,'2020-01-02 16:44:56'),(81,1,15,'2020-01-02 16:46:03'),(82,1,15,'2020-01-02 16:46:12'),(83,1,15,'2020-01-13 20:53:38'),(84,1,15,'2020-01-13 21:01:52'),(85,1,15,'2020-01-13 21:02:27'),(86,1,15,'2020-01-13 21:11:46'),(87,1,15,'2020-01-13 21:14:53'),(88,1,15,'2020-01-13 21:15:51'),(89,1,15,'2020-01-13 21:16:13'),(90,1,15,'2020-01-13 21:17:34'),(91,1,15,'2020-01-13 21:17:51'),(92,1,15,'2020-01-13 21:17:56'),(93,1,15,'2020-01-13 21:20:20'),(94,1,15,'2020-01-13 21:20:35'),(95,1,15,'2020-01-13 21:28:23'),(96,1,15,'2020-01-13 21:29:04'),(97,1,15,'2020-01-13 21:29:17'),(98,1,15,'2020-01-13 21:29:21'),(99,1,15,'2020-01-13 21:31:20');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(25) DEFAULT NULL,
  `lastname` varchar(25) DEFAULT NULL,
  `username` char(20) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `points` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Arthur','Pessoa','arthur.pessoa',0,'f65c142ac4d5654d03ae418f0a3f26ec','arthur.pessoa@praguecollege.cz',75),(2,'Administrator','','admin',1,'21232f297a57a5a743894a0e4a801fc3','admin@zerowaste.cz',0);
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

-- Dump completed on 2020-01-18 19:29:59
