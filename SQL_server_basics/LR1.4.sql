CREATE TABLE dbo.Address(
	AddressID INT NOT NULL,
	AddressLine1 VARCHAR(128),
	AddressLine2 VARCHAR(128),
	City NVARCHAR(30),
	StateProvinceiID INT,
	PostalCode NVARCHAR(128),
	ModifiedDate DATETIME,
);
GO

SELECT *
FROM dbo.Address;

DROP TABLE Address;
TRUNCATE TABLE Address;

ALTER TABLE dbo.Address
ALTER COLUMN StateProvinceiID INT NOT NULL;

ALTER TABLE dbo.Address
ALTER COLUMN PostalCode NVARCHAR(40) NOT NULL;

ALTER TABLE dbo.Address
ADD CONSTRAINT pk PRIMARY KEY (AddressID, StateProvinceiID);

ALTER TABLE dbo.Address
ADD CONSTRAINT no_letters CHECK (PostalCode NOT LIKE '%[A-z]%' AND PostalCode NOT LIKE '%[À-ÿ]%');

ALTER TABLE dbo.Address
ADD CONSTRAINT Defaultdate DEFAULT SYSDATETIME() FOR ModifiedDate;





INSERT INTO dbo.Address(AddressID, AddressLine1, AddressLine2, City, StateProvinceiID, PostalCode) VALUES (1000000, 'dsafadf', 'adsfasdfas', '2342fs', 5, '234234');
GO

SELECT *
FROM dbo.Address;


INSERT INTO dbo.Address(AddressID, AddressLine1, AddressLine2, City, StateProvinceiID, PostalCode)
SELECT Person.Address.AddressID, Person.Address.AddressLine1, Person.Address.AddressLine2, Person.Address.City, Person.Address.StateProvinceID, Person.Address.PostalCode
FROM Person.Address
INNER JOIN Person.StateProvince ON Person.StateProvince.StateProvinceID = Person.Address.StateProvinceID
WHERE Person.StateProvince.CountryRegionCode = 'US' AND Person.Address.PostalCode NOT LIKE '%[A-z]%' AND Person.Address.PostalCode NOT LIKE '%[À-ÿ]%';
