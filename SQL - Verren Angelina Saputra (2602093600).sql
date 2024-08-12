CREATE DATABASE HospitalIIE_OLAP

USE HospitalIIE_OLAP

CREATE TABLE MedicineDimension (
	MedicineCode INT PRIMARY KEY IDENTITY,
	MedicineID INT,
	MedicineName VARCHAR(255),
	MedicineExpiredDate DATE,
	MedicineSellingPrice BIGINT,
	MedicineBuyingPrice BIGINT,
	ValidTo DATETIME,
	ValidFrom DATETIME
)

DROP TABLE MedicineDimension

CREATE TABLE DoctorDimension (
	DoctorCode INT PRIMARY KEY IDENTITY,
	DoctorID INT,
	DoctorName VARCHAR(255),
	DoctorDOB DATE,
	DoctorAddress VARCHAR(255),
	DoctorSalary BIGINT,
	ValidTo DATETIME,
	ValidFrom DATETIME
)

DROP TABLE DoctorDimension

CREATE TABLE StaffDimension (
	StaffCode INT PRIMARY KEY IDENTITY,
	StaffID INT,
	StaffName VARCHAR(255),
	StaffDOB DATE,
	StaffAddress VARCHAR(255),
	StaffSalary BIGINT,
	ValidTo DATETIME,
	ValidFrom DATETIME
)

DROP TABLE StaffDimension
SELECT * FROM StaffDimension

CREATE TABLE CustomerDimension (
	CustomerCode INT PRIMARY KEY IDENTITY,
	CustomerID INT,
	CustomerName VARCHAR(255),
	CustomerGender CHAR(1),
	CustomerAddress VARCHAR(255)
)

DROP TABLE CustomerDimension

CREATE TABLE BenefitDimension (
	BenefitCode INT PRIMARY KEY IDENTITY,
	BenefitID INT,
	BenefitName VARCHAR(255),
	BenefitPrice BIGINT,
	ValidTo DATETIME,
	ValidFrom DATETIME
)

DROP TABLE BenefitDimension

CREATE TABLE TreatmentDimension (
	TreatmentCode INT PRIMARY KEY IDENTITY,
	TreatmentID INT,
	TreatmentName VARCHAR(255),
	TreatmentPrice BIGINT,
	ValidTo DATETIME,
	ValidFrom DATETIME
)

DROP TABLE TreatmentDimension

CREATE TABLE DistributorDimension (
	DistributorCode INT PRIMARY KEY IDENTITY,
	DistributorID INT,
	DistributorAddress VARCHAR(255),
	DistributorName VARCHAR(255),
	DistributorPhone VARCHAR(13),
	CityName VARCHAR(255)
)

DROP TABLE DistributorDimension

SELECT *
FROM OLTP_HospitalIE..MsDistributor MD JOIN OLTP

-- DROP TABLE DistributorDimension

CREATE TABLE TimeDimension(
	TimeCode INT PRIMARY KEY IDENTITY,
	[Date] DATE,
	[Month] INT,
	[Quarter] INT,
	[Year] INT
)

CREATE TABLE SalesFact (
	TimeCode INT,
	MedicineCode INT,
	StaffCode INT,
	CustomerCode INT,
	[Total Sales Earning] INT,
	[Total Medicine Sold] INT
)

CREATE TABLE PurchaseFact (
	TimeCode INT,
	MedicineCode INT,
	StaffCode INT,
	DistributorCode INT, 
	[Total Purchase Cost] BIGINT,
	[Total Medicine Purchase] BIGINT
)

DROP TABLE PurchaseFact

CREATE TABLE SubscriptionTransactionFact (
	TimeCode INT,
	CustomerCode INT,
	StaffCode INT,
	BenefitCode INT,
	[Total Subscription Earning] INT,
	[Number of Subscriber] INT
)

CREATE TABLE ServiceTransactionFact (
	TimeCode INT,
	CustomerCode INT,
	TreatMentCode INT,
	DoctorCode INT,
	[Total Service Earning] INT,
	[Number of Doctor] INT
)

CREATE TABLE FilterTimeStamp(
	TableName VARCHAR(255),
	LastETL DATE
)

SELECT * FROM MedicineDimension
SELECT * FROM DoctorDimension
SELECT * FROM StaffDimension
SELECT * FROM CustomerDimension
SELECT * FROM BenefitDimension
SELECT * FROM TreatmentDimension
SELECT * FROM DistributorDimension

DROP DATABASE HospitalIIE_OLAP