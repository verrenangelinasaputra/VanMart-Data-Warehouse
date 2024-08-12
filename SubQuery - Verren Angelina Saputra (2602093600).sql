-- QUERY TIME DIMENSION

IF EXISTS (
	SELECT *
	FROM HospitalIIE_OLAP..FilterTimeStamp
	WHERE TableName = 'TimeDimension'
)
BEGIN
	SELECT
		[Date] = x.[Date],
		[Month] = MONTH (x.[Date]),
		[Quarter] = DATEPART(QUARTER, x.[Date]),
		[Year] = YEAR (x.[Date])
	FROM(
		SELECT
			[Date] = SubscriptionStartDate
		FROM
			OLTP_HospitalIE..TrSubscriptionHeader
		UNION
		SELECT
			[Date] = SalesDate
		FROM
			OLTP_HospitalIE..TrSalesHeader
		UNION
		SELECT
			[Date] = ServiceDate
		FROM
			OLTP_HospitalIE..TrServiceHeader
		UNION
		SELECT
			[Date] = PurchaseDate
		FROM
			OLTP_HospitalIE..TrPurchaseHeader
	)as X, HospitalIIE_OLAP..FilterTimeStamp
	WHERE
		[Date] > LastETL AND TableName = 'TimeDimension'
END
ELSE
BEGIN
	SELECT
		[Date] = x.[Date],
		[Month] = MONTH (x.[Date]),
		[Quarter] = DATEPART(QUARTER, x.[Date]),
		[Year] = YEAR (x.[Date])
	FROM(
		SELECT
			[Date] = SubscriptionStartDate
		FROM
			OLTP_HospitalIE..TrSubscriptionHeader
		UNION
		SELECT
			[Date] = SalesDate
		FROM
			OLTP_HospitalIE..TrSalesHeader
		UNION
		SELECT
			[Date] = ServiceDate
		FROM
			OLTP_HospitalIE..TrServiceHeader
		UNION
		SELECT
			[Date] = PurchaseDate
		FROM
			OLTP_HospitalIE..TrPurchaseHeader
	)as X
END

IF EXISTS
(SELECT * FROM HospitalIIE_OLAP..FilterTimeStamp
WHERE TableName = 'TimeDimension'
)
BEGIN
	UPDATE HospitalIIE_OLAP..FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'TimeDimension'
END
ELSE
BEGIN
	INSERT INTO HospitalIIE_OLAP..FilterTimeStamp VALUES ('TimeDimension', GETDATE())
END

SELECT * FROM TimeDimension

---------------------------------------------------------------------------------------------------------------------

-- QUERY SALES FACT


IF EXISTS (
	SELECT *
	FROM HospitalIIE_OLAP..FilterTimeStamp
	WHERE TableName = 'SalesFact'
)
BEGIN
	SELECT
		TimeCode,
		MedicineCode,
		StaffCode,
		CustomerCode,
		[Total Sales Earning] = SUM(Quantity*MedicineSellingPrice),
		[Total Medicine Sold] = SUM (Quantity)
	FROM
		OLTP_HospitalIE..TrSalesHeader sh
		JOIN OLTP_HospitalIE..TrSalesDetail sd ON sh.SalesID = sd.SalesID
		JOIN HospitalIIE_OLAP..CustomerDimension cd ON cd.CustomerID = sh.CustomerID
		JOIN HospitalIIE_OLAP..StaffDimension std ON std.StaffID = sh.StaffID
		JOIN HospitalIIE_OLAP..MedicineDimension md ON md.MedicineID = sd.MedicineID
		JOIN HospitalIIE_OLAP..TimeDimension td ON td.[Date] = sh.SalesDate
	WHERE 
	sh.SalesDate > (SELECT LastETL FROM HospitalIIE_OLAP..FilterTimeStamp WHERE TableName = 'SalesFact')
	GROUP BY TimeCode, MedicineCode, StaffCode, CustomerCode
END
ELSE
BEGIN
	SELECT
		TimeCode,
		MedicineCode,
		StaffCode,
		CustomerCode,
		[Total Sales Earning] = SUM(Quantity * MedicineSellingPrice),
		[Total Medicine Sold] = SUM (Quantity)
	FROM
		OLTP_HospitalIE..TrSalesHeader sh
		JOIN OLTP_HospitalIE..TrSalesDetail sd ON sh.SalesID = sd.SalesID
		JOIN HospitalIIE_OLAP..CustomerDimension cd ON cd.CustomerID = sh.CustomerID
		JOIN HospitalIIE_OLAP..StaffDimension std ON std.StaffID = sh.StaffID
		JOIN HospitalIIE_OLAP..MedicineDimension md ON md.MedicineID = sd.MedicineID
		JOIN HospitalIIE_OLAP..TimeDimension td ON td.[Date] = sh.SalesDate
	GROUP BY TimeCode, MedicineCode, StaffCode, CustomerCode
END

IF EXISTS
(SELECT * FROM HospitalIIE_OLAP..FilterTimeStamp
WHERE TableName = 'SalesFact'
)
BEGIN
	UPDATE HospitalIIE_OLAP..FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'SalesFact'
END
ELSE
BEGIN
	INSERT INTO HospitalIIE_OLAP..FilterTimeStamp VALUES ('SalesFact', GETDATE())
END

SELECT * FROM HospitalIIE_OLAP..SalesFact



---------------------------------------------------------------------------------------------------------------------

-- QUERY PURCHASE FACT

IF EXISTS (
	SELECT *
	FROM HospitalIIE_OLAP..FilterTimeStamp
	WHERE TableName = 'PurchaseFact'
)
BEGIN
	SELECT
		TimeCode,
		MedicineCode,
		StaffCode,
		DistributorCode,
		[Total Purchase Cost] = SUM(Quantity*MedicineBuyingPrice),
		[Total Medicine Purchase] = SUM (Quantity)
	FROM
		OLTP_HospitalIE..TrPurchaseHeader ph
		JOIN OLTP_HospitalIE..TrPurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
		JOIN HospitalIIE_OLAP..DistributorDimension dd ON dd.DistributorID = ph.DistributorID
		JOIN HospitalIIE_OLAP..StaffDimension std ON std.StaffID = ph.StaffID
		JOIN HospitalIIE_OLAP..MedicineDimension md ON md.MedicineID = pd.MedicineID
		JOIN HospitalIIE_OLAP..TimeDimension td ON td.[Date] = ph.PurchaseDate
	WHERE 
	ph.PurchaseDate > (SELECT LastETL FROM HospitalIIE_OLAP..FilterTimeStamp WHERE TableName = 'PurchaseFact')
	GROUP BY TimeCode, MedicineCode, StaffCode, DistributorCode
END
ELSE
BEGIN
	SELECT
		TimeCode,
		MedicineCode,
		StaffCode,
		DistributorCode,
		[Total Purchase Cost] = SUM(Quantity*MedicineSellingPrice),
		[Total Medicine Purchase] = SUM (Quantity)
	FROM
		OLTP_HospitalIE..TrPurchaseHeader ph
		JOIN OLTP_HospitalIE..TrPurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
		JOIN HospitalIIE_OLAP..DistributorDimension dd ON dd.DistributorID = ph.DistributorID
		JOIN HospitalIIE_OLAP..StaffDimension std ON std.StaffID = ph.StaffID
		JOIN HospitalIIE_OLAP..MedicineDimension md ON md.MedicineID = pd.MedicineID
		JOIN HospitalIIE_OLAP..TimeDimension td ON td.[Date] = ph.PurchaseDate
	GROUP BY TimeCode, MedicineCode, StaffCode, DistributorCode
END


IF EXISTS
(SELECT * FROM HospitalIIE_OLAP..FilterTimeStamp
WHERE TableName = 'PurchaseFact'
)
BEGIN
	UPDATE HospitalIIE_OLAP..FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'PurchaseFact'
END
ELSE
BEGIN
	INSERT INTO HospitalIIE_OLAP..FilterTimeStamp VALUES ('SalesFact', GETDATE())
END

SELECT * FROM HospitalIIE_OLAP..PurchaseFact


---------------------------------------------------------------------------------------------------------------------

-- QUERY SUBSCRIPTION TRANSACTION FACT

IF EXISTS (
	SELECT *
	FROM HospitalIIE_OLAP..FilterTimeStamp
	WHERE TableName = 'SubscriptionTransactionFact'
)
BEGIN
	SELECT
		TimeCode,
		CustomerCode,
		StaffCode,
		BenefitCode,
		[Total Subscription Earning] = SUM(BenefitPrice),
		[Number of Subscriber] = COUNT(th.SubscriptionID)
	FROM
		OLTP_HospitalIE..TrSubscriptionHeader th
		JOIN OLTP_HospitalIE..TrSubscriptionDetail td ON th.SubscriptionID = td.SubscriptionID
		JOIN HospitalIIE_OLAP.. CustomerDimension cd ON th.CustomerID = cd.CustomerID
		JOIN HospitalIIE_OLAP..StaffDimension std ON th.StaffID = std.StaffID
		JOIN HospitalIIE_OLAP..BenefitDimension bd ON td.BenefitID = bd.BenefitID
		JOIN HospitalIIE_OLAP..TimeDimension ttd ON ttd.[Date] = th.SubscriptionStartDate
	WHERE 
	th.SubscriptionStartDate > (SELECT LastETL FROM HospitalIIE_OLAP..FilterTimeStamp WHERE TableName = 'SubscriptionTransactionFact')
	GROUP BY TimeCode, CustomerCode, StaffCode, BenefitCode
END
ELSE
BEGIN
	SELECT
		TimeCode,
		CustomerCode,
		StaffCode,
		BenefitCode,
		[Total Subscription Earning] = SUM(BenefitPrice),
		[Number of Subscriber] = COUNT(th.SubscriptionID)
	FROM
		OLTP_HospitalIE..TrSubscriptionHeader th
		JOIN OLTP_HospitalIE..TrSubscriptionDetail td ON th.SubscriptionID = td.SubscriptionID
		JOIN HospitalIIE_OLAP.. CustomerDimension cd ON th.CustomerID = cd.CustomerID
		JOIN HospitalIIE_OLAP..StaffDimension std ON th.StaffID = std.StaffID
		JOIN HospitalIIE_OLAP..BenefitDimension bd ON td.BenefitID = bd.BenefitID
		JOIN HospitalIIE_OLAP..TimeDimension ttd ON ttd.[Date] = th.SubscriptionStartDate
	GROUP BY TimeCode, CustomerCode, StaffCode, BenefitCode
END

IF EXISTS
(SELECT * FROM HospitalIIE_OLAP..FilterTimeStamp
WHERE TableName = 'SubscriptionTransactionFact'
)
BEGIN
	UPDATE HospitalIIE_OLAP..FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'SubscriptionTransactionFact'
END
ELSE
BEGIN
	INSERT INTO HospitalIIE_OLAP..FilterTimeStamp VALUES ('SubscriptionTransactionFact', GETDATE())
END

SELECT * FROM HospitalIIE_OLAP..SubscriptionTransactionFact


---------------------------------------------------------------------------------------------------------------------

-- QUERY SERVICE TRANSACTION FACT

IF EXISTS (
	SELECT *
	FROM HospitalIIE_OLAP..FilterTimeStamp
	WHERE TableName = 'ServiceTransactionFact'
)
BEGIN
	SELECT
		TimeCode,
		CustomerCode,
		TreatmentCode,
		DoctorCode,
		[Total Service Earning] = SUM(Quantity*TreatmentPrice),
		[Number of Doctors] = COUNT(dd.DoctorID)
	FROM
		OLTP_HospitalIE..TrServiceHeader th
		JOIN OLTP_HospitalIE..TrServiceDetail td ON th.ServiceID = td.ServiceID
		JOIN HospitalIIE_OLAP.. CustomerDimension cd ON th.CustomerID = cd.CustomerID
		JOIN HospitalIIE_OLAP..TreatmentDimension tr ON tr.TreatmentID = td.TreatmentID
		JOIN HospitalIIE_OLAP..DoctorDimension dd ON dd.DoctorID = th.DoctorID
		JOIN HospitalIIE_OLAP..TimeDimension ttd ON ttd.[Date] = th.ServiceDate
	WHERE 
	th.ServiceDate > (SELECT LastETL FROM HospitalIIE_OLAP..FilterTimeStamp WHERE TableName = 'ServiceTransactionFact')
	GROUP BY TimeCode, CustomerCode, TreatmentCode, DoctorCode
END
ELSE
BEGIN
	SELECT
		TimeCode,
		CustomerCode,
		TreatmentCode,
		DoctorCode,
		[Total Service Earning] = SUM(Quantity*TreatmentPrice),
		[Number of Doctors] = COUNT(dd.DoctorID)
	FROM
		OLTP_HospitalIE..TrServiceHeader th
		JOIN OLTP_HospitalIE..TrServiceDetail td ON th.ServiceID = td.ServiceID
		JOIN HospitalIIE_OLAP.. CustomerDimension cd ON th.CustomerID = cd.CustomerID
		JOIN HospitalIIE_OLAP..TreatmentDimension tr ON tr.TreatmentID = td.TreatmentID
		JOIN HospitalIIE_OLAP..DoctorDimension dd ON dd.DoctorID = th.DoctorID
		JOIN HospitalIIE_OLAP..TimeDimension ttd ON ttd.[Date] = th.ServiceDate
	GROUP BY TimeCode, CustomerCode, TreatmentCode, DoctorCode
END

IF EXISTS
(SELECT * FROM HospitalIIE_OLAP..FilterTimeStamp
WHERE TableName = 'ServiceTransactionFact'
)
BEGIN
	UPDATE HospitalIIE_OLAP..FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'ServiceTransactionFact'
END
ELSE
BEGIN
	INSERT INTO HospitalIIE_OLAP..FilterTimeStamp VALUES ('ServiceTransactionFact', GETDATE())
END

SELECT * FROM HospitalIIE_OLAP..ServiceTransactionFact