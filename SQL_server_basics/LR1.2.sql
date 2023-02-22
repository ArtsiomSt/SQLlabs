SELECT DepartmentID, Name
FROM HumanResources.Department
WHERE Name LIKE 'P%';
GO

SELECT BusinessEntityID, JobTitle, Gender, VacationHours, SickLeaveHours
FROM HumanResources.Employee
WHERE VacationHours BETWEEN 10 AND 13;
GO

SELECT BusinessEntityID, JobTitle, Gender, VacationHours, SickLeaveHours, HireDate
FROM HumanResources.Employee
WHERE MONTH(HireDate) =7 AND DAY(HireDate) = 1 
ORDER BY BusinessEntityID
OFFSET 3 ROWS FETCH NEXT 5 ROWS ONLY;
