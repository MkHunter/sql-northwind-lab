--				EJERCICIOS B)
-- 1.- Seleccionar todos los campos de la tabla clientes, 
--     ordenado por nombre del contacto de la compañía, alfabéticamente.
SELECT * FROM Customers
ORDER BY ContactName ASC
-- 2.- Seleccionar todos los campos de la tabla órdenes, 
--     ordenados por fecha de la orden, descendentemente.
SELECT * FROM Orders
ORDER BY OrderDate DESC
-- 3.- Seleccionar todos los campos de la tabla detalle de la orden, 
--     ordenada por cantidad pedida, ascendentemente. 
SELECT * --, RealPrice = (Quantity * (UnitPrice * (1 -Discount))) 
FROM [Order Details]
ORDER BY Quantity * (UnitPrice * (1 -Discount)) ASC

-- 4.- Obtener todos los productos, cuyo nombre comienzan con la letra P
--     y tienen un precio unitario comprendido entre 10 y 120.
SELECT * FROM Products
WHERE ProductName LIKE 'p%' AND 
UnitPrice BETWEEN 10 AND 120

-- 5.- Obtener todos los clientes de los países de: USA, Francia y UK. 
SELECT * FROM Customers
WHERE Country IN ('USA','France','UK')

-- 6.- Obtener todos los productos descontinuados y sin stock, 
--     que pertenecen a las categorías 1, 3, 4 y 7. 
SELECT * FROM Products
WHERE (Discontinued = 1 OR UnitsInStock = 0) AND CategoryID IN (1,3,4,7)

-- 7.- Obtener todas las ordenes hechas por el empleado con código: 2, 5 y 7 en el año 1996
SELECT * FROM Orders
WHERE EmployeeID IN (2,5,7) AND YEAR(OrderDate) = 1996

-- 8.- Seleccionar todos los clientes que cuenten con FAX.
SELECT * FROM Customers
WHERE Fax IS NOT NULL

-- 9.- Seleccionar todos los clientes que no cuenten con FAX, del país de USA.
SELECT * FROM Customers
WHERE Country = 'USA' AND Fax IS NOT NULL

-- 10.- Seleccionar todos los empleados que cuentan con un jefe.
SELECT * FROM Employees
WHERE ReportsTo IS NOT NULL

-- 11.- Seleccionar todos los campos del cliente, 
--      cuya compañía empiece con la letra de A hasta la D y 
--      pertenezcan al país de USA, ordenarlos por la dirección.
SELECT * FROM Customers
WHERE  CompanyName LIKE '[a-d]%' AND Country = 'USA'
ORDER BY Address ASC
 

 -- 12.- Seleccionar todos los campos del proveedor, 
 --      cuya compañía no comience con las letras de la B a la G, 
 --      y pertenezca al país de UK, ordenarlos por nombre de la compañía.
 SELECT * FROM Suppliers
 WHERE CompanyName NOT LIKE '[B-G]%' AND Country = 'UK'
 ORDER BY CompanyName ASC

 -- 13.- Seleccionar los productos vigentes cuyos precios unitarios están entre 35 y 250,
 --     sin stock en almacén. Pertenecientes a las categorías 1, 3, 4, 7 y 8, 
 --     que son distribuidos por los proveedores 2, 4, 6, 7 y 9. 
SELECT * FROM Products
WHERE (UnitPrice BETWEEN 35 AND 250) AND 
CategoryID IN (1,3,4,7,8) AND 
SupplierID IN (2,4,6,7,9)

-- 14.- Seleccionar todos los campos de los productos descontinuados, 
--      que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, 
--      que tengan stock en almacén, y al mismo tiempo que sus precios unitarios están 
--      entre 39 y 190, ordenados por código de proveedor y precio unitario de manera ascendente.
SELECT * FROM Products
WHERE SupplierID IN (1,3,7,8,9) AND 
UnitsInStock > 0 AND 
UnitPrice BETWEEN 39 AND 190
ORDER BY SupplierID ASC, UnitPrice ASC

-- 15.- Seleccionar los 7 productos con precios más caros, que cuenten con stock en almacén.
SELECT TOP 7 * FROM Products
WHERE UnitsInStock > 0
ORDER BY UnitPrice DESC

-- 16.- Seleccionar los 9 productos, con menos stock en almacén, que pertenezcan a la categoría 3, 5 y 8. 
SELECT TOP 9 * FROM Products
WHERE CategoryID IN (3,5,8)
ORDER BY UnitsInStock ASC

-- 17.- Seleccionar las órdenes de compra, realizadas por el empleado con código entre el 2 y el 5, 
--      además de los clientes con códigos que comienzan con las letras de la A hasta la G, 
--      del 31 de Julio de cualquier año.
SELECT * FROM Orders 
WHERE EmployeeID IN (2,5) AND 
CustomerID LIKE '[A-G]%' AND 
DAY(OrderDate) = 31 AND 
MONTH(OrderDate) = 1

-- 18.-	Seleccionar las órdenes de compra, realizadas por el empleado con código 3, 
--      de cualquier año pero solo de los últimos 5 meses (agosto - Diciembre)
SELECT *, MONTH(OrderDate) FROM Orders
WHERE EmployeeID = 3 AND MONTH(OrderDate) BETWEEN 8 AND 12

-- 19.- Seleccionar los detalles de las órdenes de compra, que tengan un monto de cantidad pedida entre 10 y 250.
SELECT *, Discount * UnitPrice * Discount FROM [Order Details]
WHERE (Discount * UnitPrice * Discount) BETWEEN 10 AND 250

--					EJERCICIOS C)
-- 1.- El codigo de la orden de compra, la fecha de la orden de compra, 
--     el codigo del producto,el nombre del producto y la cantidad pedida
SELECT od.OrderID, o.OrderDate, p.ProductID, p.ProductName, od.Quantity
FROM [Order Details] AS od
INNER JOIN Products AS p ON od.ProductID = p.ProductID
INNER JOIN Orders AS o ON od.OrderID = o.OrderID

-- 2.- Mostrar: código de la categoría, el nombre de la categoría, cod. Producto, nombre del producto y precio.
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID

-- 3.- Mostrar: número de la orden, fecha de la orden, código del producto, cantidad, precio y flete de la orden 
SELECT od.OrderID, o.OrderDate, od.ProductID, od.Quantity, od.UnitPrice, o.Freight
FROM [Order Details] AS od
INNER JOIN Orders AS o ON od.OrderID = o.OrderID

-- 4.-  Mostrar: código, nombre, ciudad y país de proveedor, código, nombre, precio, stock del producto
SELECT s.SupplierID, s.CompanyName, s.City, s.Country, p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Products AS p
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID

-- 5.- Mostrar: código y nombre de la categoría, código, nombre, precio y stock de los productos, código,
--     nombre de los proveedores 
SELECT c.CategoryID, C.CategoryName, p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, s.SupplierID, s.CompanyName
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers AS s ON s.SupplierID = p.SupplierID

-- 6.- Mostrar: núm. y fecha de la orden, nombre del producto, nombre de la categoría, nombre del proveedor 
SELECT od.OrderID, o.OrderDate, p.ProductName, c.CategoryName, s.CompanyName
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN [Order Details] AS od ON p.ProductID = od.ProductID
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
INNER JOIN Suppliers AS s ON s.SupplierID = p.SupplierID

-- 7.- Mostrar: núm. y fecha de la orden, nombre y dirección del cliente, nombre y apellidos del empleado. 
--     Nombre del producto comprado y nombre del proveedor 
SELECT o.OrderID, o.OrderDate,CustCompanyName = c.CompanyName, c.Address, e.FirstName, e.LastName, p.ProductName,SupplierCompanyName = s.CompanyName
FROM [Order Details] AS od
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
INNER JOIN Employees AS e ON o.EmployeeID = e.EmployeeID
INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
INNER JOIN Products AS p ON p.ProductID = od.ProductID
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID

-- 8.- Modificar el ejercicio 2: solo de los productos de la categorías 2, 4, 5, 7
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID IN (2,4,5,7)

-- 9.- Modificar el ejercicio 3 solo las órdenes del mes de enero de 1997
SELECT od.OrderID, o.OrderDate,  p.ProductID, p.QuantityPerUnit, p.UnitPrice, o.Freight
FROM [Order Details] AS od
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
INNER JOIN Products AS p ON p.ProductID = od.ProductID
WHERE YEAR(OrderDate) = 1997

-- 10.- Modificar el ejercicio 4 solo las productos con stock cero 
SELECT s.SupplierID, s.CompanyName, s.City,s.Country, p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Products AS p
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE UnitsInStock = 0

-- 11.- Modificar el ejercicio 5 solo con precios entre 50 y 100
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, s.SupplierID, s.CompanyName
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE p.UnitPrice BETWEEN 50 AND 100

-- 12.- Modificar el ejercicio 6 solo del primer trimestre del año 1996
SELECT od.OrderID, o.OrderDate, p.ProductName, c.CategoryName, s.CompanyName
FROM [Order Details] AS od
INNER JOIN Products AS p ON od.ProductID = p.ProductID
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
WHERE MONTH(o.OrderDate) <= 3 AND YEAR(o.OrderDate) = 1996

--					EJERCICIOS D)
-- 1.- Visualizar el máximo y el mínimo precio de los productos por categoría, mostrar el nombre de la categoría.


-- 2.- Visualizar el máximo y mínimo precio de los productos por proveedor, mostrar el nombre de la compañía proveedora.


-- 3.- Seleccionar las categorías que tengan más de 5 productos. 
--     Mostrar el nombre de la categoría y el número de productos. 


-- 4.- Calcular cuántos clientes existe en cada país. 


-- 5.- Calcular cuántos clientes existen en cada ciudad.


-- 6.- Calcular el stock total de los productos por cada categoría. 
--     Mostrar el nombre de la categoría y el stock por categoría.


-- 7.- Calcular el stock total de los productos por cada categoría. 
--     Mostrar el nombre de la categoría y el stock por categoría. Solamente las categorías 2, 5 y 8.


-- 8.- Obtener el nombre del cliente, nombre del proveedor, nombre del empleado y 
--     el nombre de los productos que están en la orden 10250.


-- 9.-  Mostrar el número de órdenes realizadas de cada uno de los clientes por año. 


-- 10.- Mostrar el número de órdenes realizadas de cada uno de los empleados en cada año.


-- 11.- Mostrar el número de órdenes realizadas de cada uno de los clientes por cada mes y año.
