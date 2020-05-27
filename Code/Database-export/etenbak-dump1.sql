-- MySQL dump 10.17  Distrib 10.3.17-MariaDB, for debian-linux-gnueabihf (armv7l)
--
-- Host: localhost    Database: ETENSBAK
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
-- Current Database: `ETENSBAK`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ETENSBAK` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `ETENSBAK`;

--
-- Table structure for table `FeedDispenser`
--

DROP TABLE IF EXISTS `FeedDispenser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FeedDispenser` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `LatestFood` int(11) NOT NULL,
  `LatestWater` int(11) NOT NULL,
  `LatestProximity` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FeedDispenser_FK` (`LatestFood`),
  KEY `FeedDispenser_FK_1` (`LatestProximity`),
  KEY `FeedDispenser_FK_2` (`LatestWater`),
  CONSTRAINT `FeedDispenser_FK` FOREIGN KEY (`LatestFood`) REFERENCES `Food` (`idFood`),
  CONSTRAINT `FeedDispenser_FK_1` FOREIGN KEY (`LatestProximity`) REFERENCES `Proximity` (`idProximity`),
  CONSTRAINT `FeedDispenser_FK_2` FOREIGN KEY (`LatestWater`) REFERENCES `Water` (`idWater`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FeedDispenser`
--

LOCK TABLES `FeedDispenser` WRITE;
/*!40000 ALTER TABLE `FeedDispenser` DISABLE KEYS */;
INSERT INTO `FeedDispenser` VALUES (1,27,29,21);
/*!40000 ALTER TABLE `FeedDispenser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Food`
--

DROP TABLE IF EXISTS `Food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Food` (
  `idFood` int(11) NOT NULL AUTO_INCREMENT,
  `Weight` varchar(45) NOT NULL,
  `CurrentTime` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`idFood`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Food`
--

LOCK TABLES `Food` WRITE;
/*!40000 ALTER TABLE `Food` DISABLE KEYS */;
INSERT INTO `Food` VALUES (15,'200','2020-05-25 17:12:07'),(16,'150','2020-05-25 17:12:08'),(17,'120','2020-05-25 17:12:08'),(18,'50','2020-05-25 17:12:08'),(19,'200','2020-05-25 17:12:08'),(20,'200','2020-05-25 17:12:09'),(21,'200','2020-05-25 17:12:09'),(22,'180','2020-05-25 17:12:09'),(23,'140','2020-05-25 17:12:09'),(24,'20','2020-05-25 17:12:09'),(25,'200','2020-05-25 17:12:09'),(26,'200','2020-05-25 17:12:10'),(27,'200','2020-05-25 17:12:10');
/*!40000 ALTER TABLE `Food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Proximity`
--

DROP TABLE IF EXISTS `Proximity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Proximity` (
  `idProximity` int(11) NOT NULL AUTO_INCREMENT,
  `Proximity` float NOT NULL,
  `CurrentTime` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`idProximity`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proximity`
--

LOCK TABLES `Proximity` WRITE;
/*!40000 ALTER TABLE `Proximity` DISABLE KEYS */;
INSERT INTO `Proximity` VALUES (1,400,'2020-05-25 17:13:43'),(2,400,'2020-05-25 17:13:43'),(3,15,'2020-05-25 17:13:44'),(4,10,'2020-05-25 17:13:44'),(5,10,'2020-05-25 17:13:44'),(6,10,'2020-05-25 17:13:44'),(7,400,'2020-05-25 17:13:45'),(8,400,'2020-05-25 17:13:45'),(9,10,'2020-05-25 17:13:46'),(10,60,'2020-05-25 17:13:46'),(11,400,'2020-05-25 17:13:46'),(12,300,'2020-05-25 17:13:47'),(13,10,'2020-05-25 17:13:47'),(14,400,'2020-05-25 17:13:48'),(15,400,'2020-05-25 17:13:48'),(16,400,'2020-05-25 17:13:49'),(17,10,'2020-05-25 17:13:49'),(18,10,'2020-05-25 17:13:50'),(19,10,'2020-05-25 17:13:50'),(20,11,'2020-05-25 17:13:50'),(21,10,'2020-05-25 17:13:51');
/*!40000 ALTER TABLE `Proximity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Water`
--

DROP TABLE IF EXISTS `Water`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Water` (
  `idWater` int(11) NOT NULL AUTO_INCREMENT,
  `EnoughWater` tinyint(4) NOT NULL,
  `CurrentTime` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`idWater`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Water`
--

LOCK TABLES `Water` WRITE;
/*!40000 ALTER TABLE `Water` DISABLE KEYS */;
INSERT INTO `Water` VALUES (1,1,'2020-05-25 17:14:30'),(2,1,'2020-05-25 17:14:30'),(3,1,'2020-05-25 17:14:30'),(4,1,'2020-05-25 17:14:30'),(5,0,'2020-05-25 17:14:31'),(6,0,'2020-05-25 17:14:31'),(7,0,'2020-05-25 17:14:31'),(8,1,'2020-05-25 17:14:31'),(9,1,'2020-05-25 17:14:31'),(10,1,'2020-05-25 17:14:31'),(11,1,'2020-05-25 17:14:31'),(12,0,'2020-05-25 17:14:32'),(13,0,'2020-05-25 17:14:32'),(14,0,'2020-05-25 17:14:32'),(15,0,'2020-05-25 17:14:32'),(16,1,'2020-05-25 17:14:32'),(17,1,'2020-05-25 17:14:32'),(18,1,'2020-05-25 17:14:33'),(19,1,'2020-05-25 17:14:33'),(20,1,'2020-05-25 17:14:33'),(21,1,'2020-05-25 17:14:33'),(22,1,'2020-05-25 17:14:33'),(23,1,'2020-05-25 17:14:33'),(24,0,'2020-05-25 17:14:33'),(25,0,'2020-05-25 17:14:34'),(26,0,'2020-05-25 17:14:34'),(27,0,'2020-05-25 17:14:34'),(28,0,'2020-05-25 17:14:35'),(29,1,'2020-05-25 17:14:35');
/*!40000 ALTER TABLE `Water` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-25 18:10:12
