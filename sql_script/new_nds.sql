--Tạo Stage
use master 
go
if DB_ID('NDS') IS NOT NULL
	ALTER DATABASE NDS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE NDS;
GO
CREATE DATABASE NDS
GO
USE NDS
GO

SELECT * FROM SYS.TABLES

DROP TABLE IF EXISTS AirQualityData_NDS
DROP TABLE IF EXISTS Counties_NDS
DROP TABLE IF EXISTS State_NDS

CREATE TABLE State_NDS (
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
SELECT * FROM State_NDS


CREATE TABLE Counties_NDS (
	County_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    County_fips CHAR(5),
    County NVARCHAR(255),
    County_ascii NVARCHAR(255),
    County_full NVARCHAR(255),
    State INT,
    Lat DECIMAL(10, 6),
    Lng DECIMAL(10, 6),
    population INT,
	Created DATETIME,
    LastUpdated DATETIME,
	SourceID INT,
	Status INT,

	--KHOA NGOAI 
	CONSTRAINT FK_Counties_NDS_State FOREIGN KEY(State) REFERENCES State_NDS(State_SK)
);
GO

CREATE TABLE AirQualityData_NDS (
	AQI_SK INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	AQI_ID INT,
    County INT,
    AQI INT,
    Category NVARCHAR(50),
	Date DATETIME,
    DefiningParameter NVARCHAR(100),
    DefiningSite NVARCHAR(100),
    NumberOfSitesReporting INT,
    Created DATETIME,
    LastUpdated DATETIME,
	SourceID INT,
	Status INT
	--KHOA NGOAI
	CONSTRAINT FK_AirQualityData_NDS_Counties FOREIGN KEY (County) REFERENCES Counties_NDS(County_SK),
);

CREATE TABLE AQI_TEMP (
    [Row_ID] int,
    [AQI] int,
    [Category] nvarchar(50),
    [DefiningParameter] nvarchar(100),
    [DefiningSite] nvarchar(100),
    [NumberOfSitesReporting] int,
    [County_fips] CHAR(5),
    [Status] int,
    [Date] date
)

-------------------------------------------------------------------------
SELECT * FROM SYS.TABLES

select * from AirQualityData_NDS
SELECT * FROM State_NDS
SELECT * FROM Counties_NDS

--------------------------------------------------DAY
--WITH Parameter_Count AS (
--    SELECT 
--        Date,
--        DefiningParameter,
--        COUNT(*) AS ParameterCount
--    FROM AirQualityData_NDS
--    GROUP BY Date, DefiningParameter
--),
--Parameter_Count_Max AS (
--    SELECT 
--        Date,
--        DefiningParameter,
--        ROW_NUMBER() OVER (PARTITION BY Date ORDER BY ParameterCount DESC) AS Rank
--    FROM Parameter_Count
--)
--SELECT 
--    AQI.Date,
--    AVG(AQI.AQI) AS AverageAQI,
--    MAX(AQI.AQI) AS MaxAQI,
--    MIN(AQI.AQI) AS MinAQI,
--    P.DefiningParameter AS MostFrequentParameter
--FROM AirQualityData_NDS AQI JOIN Parameter_Count_Max AS P ON AQI.Date = P.Date 
--WHERE P.Rank = 1 
--GROUP BY AQI.Date, P.DefiningParameter
--ORDER BY AQI.Date;
-----------------------------------------------------
--SELECT 
--    AQI.Date,
--    AVG(AQI.AQI) AS AverageAQI,
--    MAX(AQI.AQI) AS MaxAQI,
--    MIN(AQI.AQI) AS MinAQI
--FROM AirQualityData_NDS AQI 
--GROUP BY AQI.Date
--ORDER BY AQI.Date;

------------------------------------------MONTH----------------------------------------
----WITH Parameter_Count AS (
----    SELECT 
----        DATEFROMPARTS(YEAR(Date), MONTH(Date), 1) AS MonthYear,  
----        DefiningParameter,
----        COUNT(*) AS ParameterCount
----    FROM AirQualityData_NDS
----    GROUP BY DATEFROMPARTS(YEAR(Date), MONTH(Date), 1), DefiningParameter
----),
----Parameter_Count_Max AS (
----    SELECT 
----        MonthYear,
----        DefiningParameter,
----        ROW_NUMBER() OVER (PARTITION BY MonthYear ORDER BY ParameterCount DESC) AS Rank
----    FROM Parameter_Count
----)
----SELECT 
----    DATEFROMPARTS(YEAR(AQI.Date), MONTH(AQI.Date), 1) AS MonthYear,
----    AVG(AQI.AQI) AS AverageAQI,
----    MAX(AQI.AQI) AS MaxAQI,
----    MIN(AQI.AQI) AS MinAQI,
----    P.DefiningParameter AS MostFrequentParameter
----FROM AirQualityData_NDS AQI 
----JOIN Parameter_Count_Max AS P ON DATEFROMPARTS(YEAR(AQI.Date), MONTH(AQI.Date), 1) = P.MonthYear
----WHERE P.Rank = 1 
----GROUP BY DATEFROMPARTS(YEAR(AQI.Date), MONTH(AQI.Date), 1), P.DefiningParameter
----ORDER BY DATEFROMPARTS(YEAR(AQI.Date), MONTH(AQI.Date), 1);
--------------------------------------------------
--SELECT 
--    DATEFROMPARTS(YEAR(AQI.Date), MONTH(AQI.Date), 1) AS MonthYear,
--    AVG(AQI.AQI) AS AverageAQI,
--    MAX(AQI.AQI) AS MaxAQI,
--    MIN(AQI.AQI) AS MinAQI
--FROM AirQualityData_NDS AQI 
--GROUP BY DATEFROMPARTS(YEAR(AQI.Date), MONTH(AQI.Date), 1)
--ORDER BY DATEFROMPARTS(YEAR(AQI.Date), MONTH(AQI.Date), 1);


----------------------------------------------QUARTER
--WITH Parameter_Count AS (
--    SELECT 
--        CONCAT(YEAR(Date), '-', 'Q', DATEPART(QUARTER, Date)) AS QuarterYear, 
--        DATEPART(YEAR, Date) AS Year,                                       
--        'Q' + CAST(DATEPART(QUARTER, Date) AS NVARCHAR) AS Quarter,
--        DefiningParameter,
--        COUNT(*) AS ParameterCount
--    FROM AirQualityData_NDS
--    GROUP BY 
--        YEAR(Date), 
--        DATEPART(QUARTER, Date), 
--        DefiningParameter
--),
--Parameter_Count_Max AS (
--    SELECT 
--        QuarterYear,
--        Year,
--        Quarter,
--        DefiningParameter,
--        ROW_NUMBER() OVER (PARTITION BY QuarterYear ORDER BY ParameterCount DESC) AS Rank
--    FROM Parameter_Count
--)
--SELECT 
--    DATEPART(YEAR, AQI.Date) AS Year,                                      
--    'Q' + CAST(DATEPART(QUARTER, AQI.Date) AS NVARCHAR) AS Quarter, 
--    AVG(AQI.AQI) AS AverageAQI,
--    MAX(AQI.AQI) AS MaxAQI,
--    MIN(AQI.AQI) AS MinAQI,
--    P.DefiningParameter AS MostFrequentParameter
--FROM AirQualityData_NDS AQI 
--JOIN Parameter_Count_Max AS P 
--    ON CONCAT(YEAR(AQI.Date), '-', 'Q', DATEPART(QUARTER, AQI.Date)) = P.QuarterYear
--WHERE P.Rank = 1
--GROUP BY 
--    YEAR(AQI.Date), 
--    DATEPART(QUARTER, AQI.Date), 
--    CONCAT(YEAR(AQI.Date), '-', 'Q', DATEPART(QUARTER, AQI.Date)), 
--    P.DefiningParameter
--ORDER BY 
--    YEAR(AQI.Date), 
--    DATEPART(QUARTER, AQI.Date);
-------------------------------------------------
--SELECT 
--    DATEPART(YEAR, AQI.Date) AS Year,                                      
--    'Q' + CAST(DATEPART(QUARTER, AQI.Date) AS NVARCHAR) AS Quarter, 
--    AVG(AQI.AQI) AS AverageAQI,
--    MAX(AQI.AQI) AS MaxAQI,
--    MIN(AQI.AQI) AS MinAQI
--FROM AirQualityData_NDS AQI 
--GROUP BY 
--    YEAR(AQI.Date), 
--    DATEPART(QUARTER, AQI.Date), 
--    CONCAT(YEAR(AQI.Date), '-', 'Q', DATEPART(QUARTER, AQI.Date))
--ORDER BY 
--    YEAR(AQI.Date), 
--    DATEPART(QUARTER, AQI.Date);

----------------------------------------------YEAR
--WITH Parameter_Count AS (
--    SELECT 
--        YEAR(Date) AS Year,  
--        DefiningParameter,
--        COUNT(*) AS ParameterCount
--    FROM AirQualityData_NDS
--    GROUP BY YEAR(Date), DefiningParameter
--),
--Parameter_Count_Max AS (
--    SELECT 
--        Year,
--        DefiningParameter,
--        ROW_NUMBER() OVER (PARTITION BY Year ORDER BY ParameterCount DESC) AS Rank
--    FROM Parameter_Count
--)
--SELECT 
--    YEAR(AQI.Date) AS Year,
--    AVG(AQI.AQI) AS AverageAQI,
--    MAX(AQI.AQI) AS MaxAQI,
--    MIN(AQI.AQI) AS MinAQI,
--    P.DefiningParameter AS MostFrequentParameter 
--FROM AirQualityData_NDS AQI 
--JOIN Parameter_Count_Max AS P 
--    ON YEAR(AQI.Date) = P.Year 
--WHERE P.Rank = 1
--GROUP BY YEAR(AQI.Date), P.DefiningParameter
--ORDER BY YEAR(AQI.Date);
----------------------------------------------------------
--SELECT 
--    YEAR(AQI.Date) AS Year,
--    AVG(AQI.AQI) AS AverageAQI,
--    MAX(AQI.AQI) AS MaxAQI,
--    MIN(AQI.AQI) AS MinAQI
--FROM AirQualityData_NDS AQI 
--GROUP BY YEAR(AQI.Date)
--ORDER BY YEAR(AQI.Date)













