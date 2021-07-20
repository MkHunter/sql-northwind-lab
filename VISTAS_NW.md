# SQL Homework 4.2 - VISTAS Northwind

Created By: Miguel López
Date: September 19, 2018 12:43 PM
Tested ON: Miscrosoft SQL Server 2017

---

## INSTRUCCIONES

CREAR LA FAMILIA DE VISTAS DE LA SIGUIENTE BD:

![data/images/NorthwindModel.png](data/images/NorthwindModel.png)

ENTREGAS:

- [VISTAS](#VISTAS)
  - [Productos](#Productos)
  - [Órdenes](#Órdenes)
  - [Detalles de la Orden](#Detalles-de-la-Orden)
  - [Territorios](#Territorios)
  - [Empleados x Territorios](#Empleados-x-Territorios)
- [CONSULTAS](#CONSULTAS)

[Script AQUI](scripts/VistasNW.sql)

---

## VISTAS

### Productos

```sql
CREATE VIEW vw_products AS
SELECT p.ProductID, p.ProductName, p.QuantityPerUnit, ProdUnitPrice =  p.UnitPrice,
	   p.UnitsInStock, p.UnitsOnOrder, p.ReorderLevel, p.Discontinued,

	   s.SupplierID, s.CompanyName, s.ContactTitle, s.Address, s.City, s.Region,
	   s.PostalCode, s.Country, s.Phone, s.Fax, s.HomePage,

	   c.CategoryID, c.CategoryName, c.Description, c.Picture
FROM Products AS p
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
```

### Órdenes

```sql
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
```

### Detalles de la Orden

```sql
CREATE VIEW vw_orderdetails
AS
SELECT od.UnitPrice, od.Quantity, od.Discount,
	   vwo.*, vwp.*
FROM [Order Details] od
INNER JOIN vw_orders vwo ON vwo.OrderID = od.OrderID
INNER JOIN vw_products vwp ON vwp.ProductID = od.ProductID
```

### Territorios

```sql
CREATE VIEW vs_territories
AS
SELECT t.TerritoryID, t.TerritoryDescription,
	   r.RegionID, r.RegionDescription
FROM Territories t
INNER JOIN Region r ON t.RegionID = r.RegionID
```

### Empleados x Territorios

```sql
CREATE VIEW vs_employeeterritories
AS
SELECT vst.*,
	   e.EmployeeID, e.LastName, e.FirstName, e.Title, e.TitleOfCourtesy, e.BirthDate, e.HireDate,
	   e.Address, e.City,EmployeeRegion = e.Region, e.PostalCode, e.Country, e.HomePhone,
	   e.Extension, e.Photo, e.Notes, e.ReportsTo, e.PhotoPath
FROM vs_territories vst
INNER JOIN EmployeeTerritories et ON vst.TerritoryID = et.TerritoryID
INNER JOIN Employees e ON  et.EmployeeID = e.EmployeeID
```

---

## CONSULTAS

1. Consulta con el nombre de producto, nombre de la categor�a y nombre del proveedor

```sql
SELECT ProductName, CategoryName, CompanyName FROM vw_products
```

2. Consulta con el nombre del producto y el importe total de ventas

```sql
SELECT ProductName,'IMPORTE TOTAL DE VENTAS' =  SUM(Quantity * UnitPrice)
FROM vw_orderdetails
GROUP BY ProductName
ORDER BY ProductName
```

3. Nombre de las REGIONES y total de empleados que viven en ellas

```sql
SELECT RegionDescription, 'TOTAL DE EMPLEADOS' = COUNT(DISTINCT  EmployeeID)
FROM vs_employeeterritories
GROUP BY RegionDescription
```

4. Nombre del cliente, importe total de ventas

```sql
SELECT CustomerCompanyName, 'IMPORTE TOTAL DE VENTAS' = SUM(Quantity * UnitPrice)
FROM vw_orderdetails
GROUP BY CustomerCompanyName
```

5. Consulta con el folio de la orden, importe total de venta

```sql
SELECT OrderID, sum(Quantity * UnitPrice) Total
FROM vw_orderdetails
GROUP BY OrderID
ORDER BY Total DESC
```

6. Consulta con el nombre del cliente, importe total de ventas

```sql
SELECT CustomerID, Importe = sum(Quantity * UnitPrice)
FROM vw_orderdetails
GROUP BY CustomerID
ORDER BY Importe DESC
```

7. Consulta con el nombre del empleado, total de ordenes realizadas e importe total de ventas

```sql
SELECT EmployeeID, 'Ordenes Realizadas' = COUNT(*), 'Importe Total' = SUM(Quantity * UnitPrice)
FROM vw_orderdetails
GROUP BY EmployeeID
ORDER BY 'Ordenes Realizadas' DESC,'Importe Total' DESC
```

8. Nombre de la categoría, total de productos vendidos, total de ordenes donde se surtió

```sql
SELECT CategoryName, 'Productos Vendidos' = COUNT(*)
FROM vw_orderdetails
GROUP BY CategoryName
```

```sql
SELECT * FROM vw_products
SELECT * FROM vw_orders
SELECT * FROM vw_orderdetails
SELECT * FROM vs_territories
SELECT * FROM vs_employeeterritories
```

```sql
-- Revisar el Contenido de las vistas
sp_helptext vw_products
sp_helptext vw_orders
sp_helptext vw_orderdetails
sp_helptext vs_territories
sp_helptext vs_employeeterritories
```
