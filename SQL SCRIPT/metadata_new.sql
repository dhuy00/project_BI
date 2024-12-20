﻿--Tạo metadata
use master 
go
if DB_ID('METADATA') IS NOT NULL
	DROP DATABASE  METADATA
GO
CREATE DATABASE METADATA
GO
USE METADATA
GO

------------------------------------------DATA FLOW CHO STAGE------------------------------------------
DROP TABLE IF EXISTS DATA_FLOW_STAGE
GO
CREATE TABLE DATA_FLOW_STAGE (
	ID INT NOT NULL IDENTITY(1, 1),
	TABLE_NAME VARCHAR(50),
	LSET DATETIME,
	CET DATETIME,
	STATUS VARCHAR(30) DEFAULT 'UNDEFINED',
	ROW_COUNT INT DEFAULT 0,
)
GO

TRUNCATE TABLE DATA_FLOW_STAGE

--INSERT DU LIEU VAO METADATA
INSERT INTO DATA_FLOW_STAGE (TABLE_NAME, LSET, CET)
VALUES 
    ('US_COUNTIES', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('STATE_AQI', '2015-01-01 00:00:00', '2015-01-01 00:00:00')
GO

SELECT * FROM DATA_FLOW_STAGE

------------------------------------------DATA FLOW CHO NDS------------------------------------------
DROP TABLE IF EXISTS DATA_FLOW_NDS
GO
CREATE TABLE DATA_FLOW_NDS (
	ID INT NOT NULL IDENTITY(1, 1),
	TABLE_NAME VARCHAR(50),
	LSET DATETIME,
	CET DATETIME,
	STATUS VARCHAR(30) DEFAULT 'UNDEFINED',
	ROW_INSERT INT DEFAULT 0,
	ROW_UPDATE INT DEFAULT 0
)
GO

TRUNCATE TABLE DATA_FLOW_NDS

--INSERT DU LIEU VAO METADATA
INSERT INTO DATA_FLOW_NDS (TABLE_NAME, LSET, CET)
VALUES 
    ('State_NDS', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('Counties_NDS', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('AirQualityData_NDS', '2015-01-01 00:00:00', '2015-01-01 00:00:00')
GO

SELECT * FROM DATA_FLOW_NDS

------------------------------------------DATA FLOW CHO DDS------------------------------------------
DROP TABLE IF EXISTS DATA_FLOW_DDS
GO
CREATE TABLE DATA_FLOW_DDS (
	ID INT NOT NULL IDENTITY(1, 1),
	TABLE_NAME VARCHAR(50),
	LSET DATETIME,
	CET DATETIME,
	STATUS VARCHAR(30) DEFAULT 'UNDEFINED',
	ROW_INSERT INT DEFAULT 0,
	ROW_UPDATE INT DEFAULT 0
)
GO

TRUNCATE TABLE DATA_FLOW_DDS

--INSERT DU LIEU VAO METADATA
INSERT INTO DATA_FLOW_DDS (TABLE_NAME, LSET, CET)
VALUES 
    ('Dim_State', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('Fact_AirQualityData', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('AirQualityData_DataMining', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('Dim_Year', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('Dim_Category', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('Dim_Quarter', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('Dim_Counties', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('Dim_Month', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
	('Dim_Day', '2015-01-01 00:00:00', '2015-01-01 00:00:00')
GO

SELECT * FROM DATA_FLOW_DDS

