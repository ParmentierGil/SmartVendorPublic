-- MySQL dump 10.17  Distrib 10.3.22-MariaDB, for debian-linux-gnueabihf (armv8l)
--
-- Host: localhost    Database: vendingmachine
-- ------------------------------------------------------
-- Server version	10.3.22-MariaDB-0+deb10u1

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
-- Table structure for table `Actuator`
--

DROP TABLE IF EXISTS `Actuator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Actuator` (
  `ActuatorId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  PRIMARY KEY (`ActuatorId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Actuator`
--

LOCK TABLES `Actuator` WRITE;
/*!40000 ALTER TABLE `Actuator` DISABLE KEYS */;
INSERT INTO `Actuator` VALUES (1,'ServoLB'),(2,'ServoRB'),(3,'ServoLO'),(4,'ServoRO'),(5,'LCD');
/*!40000 ALTER TABLE `Actuator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ActuatorHistory`
--

DROP TABLE IF EXISTS `ActuatorHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ActuatorHistory` (
  `VendingMachineId` int(11) NOT NULL,
  `ActuatorId` int(11) NOT NULL,
  `Action` varchar(20) NOT NULL,
  `ActionTime` datetime NOT NULL,
  PRIMARY KEY (`VendingMachineId`,`ActuatorId`),
  KEY `ActuatorHistory_FK_1` (`ActuatorId`),
  CONSTRAINT `ActuatorHistory_FK` FOREIGN KEY (`VendingMachineId`) REFERENCES `VendingMachine` (`VendingMachineId`),
  CONSTRAINT `ActuatorHistory_FK_1` FOREIGN KEY (`ActuatorId`) REFERENCES `Actuator` (`ActuatorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ActuatorHistory`
--

LOCK TABLES `ActuatorHistory` WRITE;
/*!40000 ALTER TABLE `ActuatorHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `ActuatorHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Order`
--

DROP TABLE IF EXISTS `Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Order` (
  `OrderId` int(11) NOT NULL AUTO_INCREMENT,
  `ProductId` int(11) NOT NULL,
  `MomentOfPurchase` datetime NOT NULL DEFAULT current_timestamp(),
  `VendingMachineId` int(11) NOT NULL,
  `MoneyPaid` decimal(10,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`OrderId`),
  KEY `Order_FK` (`ProductId`),
  KEY `Order_FK_1` (`VendingMachineId`),
  CONSTRAINT `Order_FK` FOREIGN KEY (`ProductId`) REFERENCES `Product` (`ProductId`),
  CONSTRAINT `Order_FK_1` FOREIGN KEY (`VendingMachineId`) REFERENCES `VendingMachine` (`VendingMachineId`)
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
  `ProductId` int(11) NOT NULL AUTO_INCREMENT,
  `Price` decimal(10,0) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Weight` float DEFAULT NULL,
  `StockCount` int(11) DEFAULT NULL,
  `SoldCount` int(11) DEFAULT NULL,
  `NumberInVendingMachine` int(11) DEFAULT NULL,
  PRIMARY KEY (`ProductId`),
  KEY `Product_Price_IDX` (`Price`,`Name`) USING BTREE,
  KEY `Product_Name_IDX` (`Name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product`
--

LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */;
INSERT INTO `Product` VALUES (2,1,'Zout Chips',100,10,0,0),(3,1,'Paprika Chips',100,10,0,0),(4,1,'Pickles Chips',100,10,0,0),(5,1,'Salt & Pepper Chips',100,10,0,0),(6,1,'Ketchup Chips',100,10,0,20),(7,1,'Bugles Chips',100,10,0,0),(8,1,'Barbecue Chips',100,10,0,0),(9,1,'Mars',50,10,0,0),(10,1,'Twix',70,10,0,0),(11,1,'Bounty',50,10,0,30),(12,1,'Leo',50,10,0,1111),(13,1,'Kinder Beuno',50,10,0,0),(14,1,'Lion',50,10,0,0),(15,1,'Milky Way',50,10,0,69);
/*!40000 ALTER TABLE `Product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sensor`
--

DROP TABLE IF EXISTS `Sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Sensor` (
  `SensorId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  PRIMARY KEY (`SensorId`),
  KEY `Sensor_Name_IDX` (`Name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sensor`
--

LOCK TABLES `Sensor` WRITE;
/*!40000 ALTER TABLE `Sensor` DISABLE KEYS */;
INSERT INTO `Sensor` VALUES (2,'Muntstuk Acceptor'),(1,'OneWireTempSensor'),(3,'Weeg Sensor');
/*!40000 ALTER TABLE `Sensor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SensorHistory`
--

DROP TABLE IF EXISTS `SensorHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SensorHistory` (
  `VendingMachineId` int(11) NOT NULL,
  `SensorId` int(11) NOT NULL,
  `MeasuredValue` float DEFAULT NULL,
  `ActionTime` datetime NOT NULL,
  `Action` varchar(20) NOT NULL,
  PRIMARY KEY (`VendingMachineId`,`SensorId`),
  KEY `SensorHistoriek_FK_1` (`SensorId`),
  CONSTRAINT `SensorHistoriek_FK` FOREIGN KEY (`VendingMachineId`) REFERENCES `VendingMachine` (`VendingMachineId`),
  CONSTRAINT `SensorHistoriek_FK_1` FOREIGN KEY (`SensorId`) REFERENCES `Sensor` (`SensorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SensorHistory`
--

LOCK TABLES `SensorHistory` WRITE;
/*!40000 ALTER TABLE `SensorHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `SensorHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VendingMachine`
--

DROP TABLE IF EXISTS `VendingMachine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `VendingMachine` (
  `VendingMachineId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `MaxTemperature` int(11) NOT NULL,
  PRIMARY KEY (`VendingMachineId`),
  KEY `VendingMachine_Name_IDX` (`Name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VendingMachine`
--

LOCK TABLES `VendingMachine` WRITE;
/*!40000 ALTER TABLE `VendingMachine` DISABLE KEYS */;
INSERT INTO `VendingMachine` VALUES (1,'Project Vending Machine',25);
/*!40000 ALTER TABLE `VendingMachine` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-28 11:35:12
