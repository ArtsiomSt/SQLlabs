SELECT HumanResources.Employee.BusinessEntityID, JobTitle, HumanResources.Department.DepartmentID, HumanResources.Department.Name
FROM HumanResources.Employee
INNER JOIN HumanResources.EmployeeDepartmentHistory ON HumanResources.EmployeeDepartmentHistory.BusinessEntityID = HumanResources.Employee.BusinessEntityID
INNER JOIN HumanResources.Department On HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID;


SELECT HumanResources.Department.DepartmentID, HumanResources.Department.Name, COUNT(*) AS EmpCount
FROM HumanResources.Department
INNER JOIN HumanResources.EmployeeDepartmentHistory ON HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID
GROUP BY HumanResources.Department.DepartmentID, HumanResources.Department.Name; 


SELECT HumanResources.Employee.JobTitle, HumanResources.EmployeePayHistory.Rate, HumanResources.EmployeePayHistory.RateChangeDate, 'The rate for '+ HumanResources.Employee.JobTitle + ' was set to' + CAST(HumanResources.EmployeePayHistory.Rate AS VARCHAR(20)) + ' at ' + FORMAT(HumanResources.EmployeePayHistory.RateChangeDate, 'dd MMM yyyy')
FROM HumanResources.Employee
INNER JOIN HumanResources.EmployeePayHistory ON HumanResources.Employee.BusinessEntityID = HumanResources.EmployeePayHistory.BusinessEntityID;


SELECT 'ABC' + STR(1);