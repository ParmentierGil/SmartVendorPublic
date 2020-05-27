-- MySQL dump 10.17  Distrib 10.3.17-MariaDB, for debian-linux-gnueabihf (armv7l)
--
-- Host: localhost    Database: vendingmachine
-- ------------------------------------------------------
-- Server version	10.3.17-MariaDB-0+deb10u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `vendingmachine`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `vendingmachine` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `vendingmachine`;

--
-- Table structure for table `Order`
--

DROP TABLE IF EXISTS `Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Order` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `ProductId` int(11) NOT NULL,
  `MomentOfPurchase` datetime NOT NULL DEFAULT current_timestamp(),
  `VendingMachineId` int(11) NOT NULL,
  `MoneyPaid` decimal(10,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `Order_FK` (`ProductId`),
  KEY `Order_FK_1` (`VendingMachineId`),
  CONSTRAINT `Order_FK` FOREIGN KEY (`ProductId`) REFERENCES `Product` (`Id`),
  CONSTRAINT `Order_FK_1` FOREIGN KEY (`VendingMachineId`) REFERENCES `VendingMachine` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Order`
--

LOCK TABLES `Order` WRITE;
/*!40000 ALTER TABLE `Order` DISABLE KEYS */;
INSERT INTO `Order` VALUES (1,5,'2020-05-25 17:27:34',1,1),(2,10,'2020-05-25 17:27:34',1,1),(3,14,'2020-05-25 17:27:34',1,1),(4,12,'2020-05-25 17:27:34',1,1),(6,2,'2020-05-25 17:27:50',1,1),(7,6,'2020-05-25 17:28:21',1,1),(8,4,'2020-05-25 17:28:58',1,1),(9,4,'2020-05-25 17:29:30',1,1),(10,9,'2020-05-25 17:29:30',1,1),(11,7,'2020-05-25 17:29:30',1,1),(12,7,'2020-05-25 17:29:30',1,1),(13,8,'2020-05-25 17:29:30',1,1);
/*!40000 ALTER TABLE `Order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Product` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Price` decimal(10,0) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Weight` float DEFAULT NULL,
  `StockCount` int(11) DEFAULT NULL,
  `SoldCount` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `Product_Price_IDX` (`Price`,`Name`) USING BTREE,
  KEY `Product_Name_IDX` (`Name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product`
--

LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */;
INSERT INTO `Product` VALUES (2,1,'Zout Chips',100,10,0),(3,1,'Paprika Chips',100,10,0),(4,1,'Pickles Chips',100,10,0),(5,1,'Salt & Pepper Chips',100,10,0),(6,1,'Ketchup Chips',100,10,0),(7,1,'Bugles Chips',100,10,0),(8,1,'Barbecue Chips',100,10,0),(9,1,'Mars',50,10,0),(10,1,'Twix',70,10,0),(11,1,'Bounty',50,10,0),(12,1,'Leo',50,10,0),(13,1,'Kinder Beuno',50,10,0),(14,1,'Lion',50,10,0),(15,1,'Milky Way',50,10,0);
/*!40000 ALTER TABLE `Product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Temperature`
--

DROP TABLE IF EXISTS `Temperature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Temperature` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `TimeOfTemp` datetime NOT NULL DEFAULT current_timestamp(),
  `TemperatureValue` float NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `Temperature_TemperatureValue_IDX` (`TemperatureValue`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Temperature`
--

LOCK TABLES `Temperature` WRITE;
/*!40000 ALTER TABLE `Temperature` DISABLE KEYS */;
INSERT INTO `Temperature` VALUES (1,'2020-05-25 17:17:02',10),(2,'2020-05-25 17:17:02',20),(3,'2020-05-25 17:17:02',25),(4,'2020-05-25 17:17:02',16),(5,'2020-05-25 17:17:02',19),(6,'2020-05-25 17:17:02',23),(7,'2020-05-25 17:17:02',14),(8,'2020-05-25 17:17:02',24),(9,'2020-05-25 17:17:02',27),(10,'2020-05-25 17:17:02',16),(11,'2020-05-25 17:17:02',23),(12,'2020-05-25 17:17:02',19);
/*!40000 ALTER TABLE `Temperature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VendingMachine`
--

DROP TABLE IF EXISTS `VendingMachine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `VendingMachine` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `TotalMoney` decimal(10,0) NOT NULL DEFAULT 0,
  `Name` varchar(100) NOT NULL,
  `LatestTemperature` int(11) NOT NULL,
  `LatestWeight` int(11) NOT NULL,
  `MaxTemperature` float NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `VendingMachine_FK` (`LatestTemperature`),
  KEY `VendingMachine_FK_1` (`LatestWeight`),
  KEY `VendingMachine_Name_IDX` (`Name`) USING BTREE,
  CONSTRAINT `VendingMachine_FK` FOREIGN KEY (`LatestTemperature`) REFERENCES `Temperature` (`Id`),
  CONSTRAINT `VendingMachine_FK_1` FOREIGN KEY (`LatestWeight`) REFERENCES `Weight` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VendingMachine`
--

LOCK TABLES `VendingMachine` WRITE;
/*!40000 ALTER TABLE `VendingMachine` DISABLE KEYS */;
INSERT INTO `VendingMachine` VALUES (1,0,'Project Vending Machine',12,16,25);
/*!40000 ALTER TABLE `VendingMachine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Weight`
--

DROP TABLE IF EXISTS `Weight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Weight` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `WeightValue` float DEFAULT NULL,
  `TimeOfWeight` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`Id`),
  KEY `Weight_WeightValue_IDX` (`WeightValue`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Weight`
--

LOCK TABLES `Weight` WRITE;
/*!40000 ALTER TABLE `Weight` DISABLE KEYS */;
INSERT INTO `Weight` VALUES (1,2,'2020-05-25 17:22:12'),(2,6,'2020-05-25 17:22:12'),(3,19,'2020-05-25 17:22:12'),(4,1,'2020-05-25 17:22:12'),(5,7,'2020-05-25 17:22:12'),(6,9,'2020-05-25 17:22:12'),(7,6,'2020-05-25 17:22:12'),(8,3,'2020-05-25 17:22:12'),(9,26,'2020-05-25 17:22:12'),(10,50,'2020-05-25 17:22:12'),(11,2,'2020-05-25 17:22:12'),(12,3,'2020-05-25 17:22:12'),(13,7,'2020-05-25 17:22:12'),(14,90,'2020-05-25 17:22:12'),(15,100,'2020-05-25 17:22:12'),(16,120,'2020-05-25 17:22:13');
/*!40000 ALTER TABLE `Weight` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-25 18:03:22
