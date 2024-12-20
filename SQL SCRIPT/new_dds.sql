--Tạo Stage
use master 
go
if DB_ID('DDS') IS NOT NULL
	ALTER DATABASE DDS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE  DDS;
GO
CREATE DATABASE DDS
GO
USE DDS
GO

DROP TABLE IF EXISTS Fact_AirQualityData
DROP TABLE IF EXISTS Dim_Counties
DROP TABLE IF EXISTS Dim_State
DROP TABLE IF EXISTS Dim_Day
DROP TABLE IF EXISTS Dim_Month
DROP TABLE IF EXISTS Dim_Quarter
DROP TABLE IF EXISTS Dim_Year
DROP TABLE IF EXISTS Dim_Category

CREATE TABLE Dim_Category (
	Category_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	Category_value NVARCHAR(50),
	Created DATETIME,
	LastUpdated DATETIME,
	SourceID INT,
	Status INT,
)
GO

CREATE TABLE Dim_State (
	State_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    State_code INT,
    StateName NVARCHAR(100),
    State_id NVARCHAR(5),
	Created DATETIME,
    LastUpdated DATETIME,
	SourceID INT,
	Status INT,
);
GO

CREATE TABLE Dim_Counties (
	County_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    County_fips CHAR(5),
    County NVARCHAR(255),
    County_ascii NVARCHAR(255),
    County_full NVARCHAR(255),
    State_id INT,
    Lat DECIMAL(10, 6),
    Lng DECIMAL(10, 6),
    population INT,
	Created DATETIME,
    LastUpdated DATETIME,
	SourceID INT,
	Status INT,

	--KHOA NGOAI 
	CONSTRAINT FK_Counties_State FOREIGN KEY(State_id) REFERENCES Dim_State(State_SK)
);
GO

CREATE TABLE Dim_Year (
	Year_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Year_value INT,
);
GO

CREATE TABLE Dim_Quarter (
	Quarter_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Quarter_value INT,
	Year_id INT,

	CONSTRAINT FK_Quarter_Year FOREIGN KEY(Year_id) REFERENCES Dim_Year(Year_SK)
);
GO


CREATE TABLE Dim_Month (
	Month_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Month_value INT,
	Quarter_id INT,

	CONSTRAINT FK_Month_Quarter FOREIGN KEY (Quarter_id) REFERENCES Dim_Quarter(Quarter_SK)
);
GO

CREATE TABLE Dim_Day (
	Day_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Day_value INT,
	Month_id INT,
	DayLightSaving CHAR(5) CHECK (DayLightSaving IN ('TRUE', 'FALSE')),

	CONSTRAINT FK_Day_Month FOREIGN KEY (Month_id) REFERENCES Dim_Month(Month_SK)
)
GO

CREATE TABLE Fact_AirQualityData (
	AQI_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	AQI_ID INT,
    Day_id INT, -- natural key
    County_id INT, --natural key
	Category_id INT, --natural key
    AQI INT,
    Created DATETIME,
    LastUpdated DATETIME,
	SourceID INT,
	Status INT
	--KHOA NGOAI
	CONSTRAINT FK_AirQualityData_Counties FOREIGN KEY (County_id) REFERENCES Dim_Counties(County_SK),
	CONSTRAINT FK_AirQualityData_Date FOREIGN KEY (Day_id) REFERENCES Dim_Day(Day_SK),
	CONSTRAINT FK_AirQualityData_Category FOREIGN KEY (Category_id) REFERENCES Dim_Category(Category_SK)
);

CREATE TABLE AirQualityData_DataMining (
	AirQualityData_Key INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	StateName NVARCHAR(100),
	CountyName NVARCHAR(255),
	Day INT,
	Month INT,
	Quarter INT,
	Year INT,
	DefiningParameter NVARCHAR(100),
	DefiningSite NVARCHAR(100),
	NumberOfSitesReporting INT,
	DayLightSaving CHAR(5) CHECK (DayLightSaving IN ('TRUE', 'FALSE')),
    Lat DECIMAL(10, 6),
    Lng DECIMAL(10, 6),
    population INT,
	AQI INT,
)

SELECT * FROM SYS.TABLES
SELECT * FROM Dim_State
SELECT * FROM Fact_AirQualityData
SELECT * FROM Dim_Year
SELECT * FROM Dim_Category
SELECT * FROM Dim_Quarter
SELECT * FROM Dim_Counties
SELECT * FROM Dim_Month
SELECT * FROM Dim_Day
SELECT * FROM AirQualityData_DataMining

CREATE TABLE DataMining_Temp (
	Table_Key INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	Year INT,
	AQI INT
)

CREATE TABLE DataMining_CaseTable (
	CaseTable_Key INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	Day INT,
	Month INT,
	Quarter INT,
	Year INT,
)

-- Thêm dữ liệu mẫu
INSERT INTO DataMining_CaseTable (Day, Month, Quarter, Year)
VALUES 
(1, 1, 1, 2023),
(15, 2, 1, 2023),
(10, 4, 2, 2023),
(25, 6, 2, 2023),
(5, 9, 3, 2023),
(20, 11, 4, 2023),
(31, 12, 4, 2023);
