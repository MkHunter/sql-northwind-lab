USE NorthWind
GO
-- VISTA PRODUCTS
CREATE VIEW vw_products AS
SELECT p.ProductID, p.ProductName, p.QuantityPerUnit, ProdUnitPrice =  p.UnitPrice,
	   p.UnitsInStock, p.UnitsOnOrder, p.ReorderLevel, p.Discontinued,

	   s.SupplierID, s.CompanyName, s.ContactTitle, s.Address, s.City, s.Region,
	   s.PostalCode, s.Country, s.Phone, s.Fax, s.HomePage,

	   c.CategoryID, c.CategoryName, c.Description, c.Picture
FROM Products AS p
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
GO
-- VISTA ORDERS
CREATE VIEW vw_orders
AS
SELECT o.OrderID, o.OrderDate, o.RequiredDate, o.ShippedDate, o.Freight, o.ShipName, o.ShipAddress,
	   o.ShipCity, o.ShipRegion, o.ShipPostalCode, o.ShipCountry,

	   e.EmployeeID, e.LastName, e.FirstName, e.Title, e.TitleOfCourtesy, e.BirthDate, e.HireDate,
	   EmployeeAdress = e.Address, EmployeeCity = e.City,EmployeeRegion = e.Region,EmployeeCP = e.PostalCode,
	   EmployeeCountry = e.Country, e.HomePhone, e.Extension, e.Photo, e.Notes, e.ReportsTo, e.PhotoPath,

	   s.ShipperID,SupplierCompanyName = s.CompanyName, SupplierPhone = s.Phone,

	   c.CustomerID, CustomerCompanyName = c.CompanyName, c.ContactName, CustomerContactTitle = c.ContactTitle,
	   CustomerAddress = c.Address, CutomerCity = c.City,CustomerRegion = c.Region,CustomerCP = c.PostalCode,
	   CustomerCountry = c.Country, CustomerPhone = c.Phone, CustomerFax = c.Fax
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN Shippers s ON o.ShipVia = s.ShipperID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
GO
-- VISTA [ORDERDETAILS]
CREATE VIEW vw_orderdetails
AS
SELECT od.UnitPrice, od.Quantity, od.Discount,
	   vwo.*, vwp.*
FROM [Order Details] od
INNER JOIN vw_orders vwo ON vwo.OrderID = od.OrderID
INNER JOIN vw_products vwp ON vwp.ProductID = od.ProductID
GO
CREATE VIEW vs_territories
AS
SELECT t.TerritoryID, t.TerritoryDescription,
	   r.RegionID, r.RegionDescription
FROM Territories t
INNER JOIN Region r ON t.RegionID = r.RegionID
GO
-- VISTA TERRITORIES
CREATE VIEW vs_territories
AS
SELECT t.TerritoryID, t.TerritoryDescription,
	   r.RegionID, r.RegionDescription
FROM Territories t
INNER JOIN Region r ON t.RegionID = r.RegionID
GO
-- VISTA EMPLOYEE-TERRITORIES
CREATE VIEW vs_employeeterritories
AS
SELECT vst.*,
	   e.EmployeeID, e.LastName, e.FirstName, e.Title, e.TitleOfCourtesy, e.BirthDate, e.HireDate,
	   e.Address, e.City,EmployeeRegion = e.Region, e.PostalCode, e.Country, e.HomePhone,
	   e.Extension, e.Photo, e.Notes, e.ReportsTo, e.PhotoPath
FROM vs_territories vst
INNER JOIN EmployeeTerritories et ON vst.TerritoryID = et.TerritoryID
INNER JOIN Employees e ON  et.EmployeeID = e.EmployeeID
GO
SELECT * FROM vw_products
SELECT * FROM vw_orders
SELECT * FROM vw_orderdetails
SELECT * FROM vs_territories
SELECT * FROM vs_employeeterritories
GO
-- CONSULTAS
-- 1. Consulta con el nombre de producto, nombre de la categoría y nombre del proveedor
SELECT ProductName, CategoryName, CompanyName FROM vw_products
GO
-- 2. Consulta con el nombre del producto y el importe total de ventas
SELECT ProductName,'IMPORTE TOTAL DE VENTAS' =  SUM(Quantity * UnitPrice)  
FROM vw_orderdetails
GROUP BY ProductName
ORDER BY ProductName
-- 3.	Nombre de las REGIONES y total de empleados que viven en ellas
SELECT RegionDescription, 'TOTAL DE EMPLEADOS' = COUNT(DISTINCT  EmployeeID)
FROM vs_employeeterritories
GROUP BY RegionDescription
GO
-- 4. Nombre del cliente, importe total de ventas
SELECT CustomerCompanyName, 'IMPORTE TOTAL DE VENTAS' = SUM(Quantity * UnitPrice) 
FROM vw_orderdetails
GROUP BY CustomerCompanyName
GO
-- 5. Consulta con el folio de la orden, importe total de venta
SELECT OrderID, sum(Quantity * UnitPrice) Total
FROM vw_orderdetails
GROUP BY OrderID
ORDER BY Total DESC
GO
-- 6. Consulta con el nombre del cliente, importe total de ventas
SELECT CustomerID, Importe = sum(Quantity * UnitPrice)
FROM vw_orderdetails
GROUP BY CustomerID
ORDER BY Importe DESC
GO
-- 7. Consulta con el nombre del empleado, total de ordenes realizadas e importe total de ventas
SELECT EmployeeID, 'Ordenes Realizadas' = COUNT(*), 'Importe Total' = SUM(Quantity * UnitPrice)
FROM vw_orderdetails
GROUP BY EmployeeID
ORDER BY 'Ordenes Realizadas' DESC,'Importe Total' DESC
GO
-- 8. Nombre de la categoría, total de productos vendidos, total de ordenes donde se surtió (?)
SELECT CategoryName, 'Productos Vendidos' = COUNT(*)
FROM vw_orderdetails
GROUP BY CategoryName
GO
-- Revisar el Contenido de las vistas
sp_helptext vw_products
sp_helptext vw_orders
sp_helptext vw_orderdetails
sp_helptext vs_territories
sp_helptext vs_employeeterritories