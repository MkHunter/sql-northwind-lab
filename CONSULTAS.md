# SQL Homework 1 - CONSULTAS NORTHWIND

Created By: Miguel López
Date: September 5, 2018 4:58 PM
Tested ON: Miscrosoft SQL Server 2017

---

## INSTRUCCIONES

USANDO LA FAMILIA DE VISTAS DE LA BASE DE DATOS NORTHWIND CONTESTAR LAS SIGUIENTES CONSULTAS.

![data/images/NorthwindModel.png](data/images/NorthwindModel.png)

ENTREGAS

- [CONSULTAS](#CONSULTAS)
  - [EJERCICIOS A)](#EJERCICIOS-A)
  - [EJERCICIOS B)](#EJERCICIOS-B)
  - [EJERCICIOS C)](#EJERCICIOS-C)
  - [EJERCICIOS D)](#EJERCICIOS-D)

[Script AQUI](scripts/Consultas.sql)

---

## CONSULTAS

### EJERCICIOS A)

1. Mostrar el nombre completo del empleado imprimiendo el nombre en un renglón y el apellido en otro

```sql
SELECT FirstName + CHAR(10) + LastName + CHAR(10)
FROM Employees
```

2. Mostrar los empleados que tengan una antigüedad menor a 15 años

```sql
SELECT *
FROM Employees
WHERE DATEDIFF(YYYY,BirthDate,GETDATE())<15
```

3. Consulta con el nombre del empleado y la fecha de nacimiento, debe aparece de la siguiente forma cada empleado: `JOSE PEREZ NACIO EL DIA 2 DE FEBRERO DE 1998`

```sql
SELECT FirstName + ' ' + LastName + ' nacio el dia ' +
CAST(DAY(BirthDate) AS VARCHAR)+ ' de ' +
DATENAME(MM,BirthDate) + ' del' +
cast(YEAR(BirthDate) AS VARCHAR)
FROM Employees
```

4. Consulta con la clave y fecha de la orden que se hayan realizado hace 12 años

```sql
SELECT OrderID,OrderDate
FROM Orders
WHERE DATEDIFF(YYYY,OrderDate,GETDATE())=12
```

5. Consulta con las clave de la orden y fecha de la orden. mostrar solamente las ordenes que se hayan realizado los fines de semana

```sql
SELECT OrderID,OrderDate,DATEName(WEEKDAY,OrderDate)
FROM Orders
WHERE DATEPART(WEEKDAY,OrderDate) IN (6,7)
```

6. Consultar en una sola columna la siguiente información de cada orden: `La orden 1 fue realizada el día lunes de la fecha 23 de octubre de 2008`

```sql
SELECT 'La orden ' + CAT(orderid AS VARCHAR) + ' fue realizada el dia' + DATENAME(WEEKDAY,OrderDate) + ' de la fecha ' + CAST(DAY(OrderDate) AS VARCHAR) + ' ' + DATENAME(MM,OrderDate) + ' de ' + cast(YEAR(Orderdate) AS VARCHAR)
FROM Orders
```

7. Consulta con los clientes cuya nombre sea mayor a 10 caracteres

```sql
SELECT *
FROM Customers
WHERE LEN(ContactName)>10
```

8. Consulta con los productos que su nombre empieza con vocal

```sql
SELECT *
FROM Products
WHERE ProductName LIKE '[aeiou]%'
```

9. Consulta con los empleados que su apellido empiece con consonante

```sql
SELECT *
FROM Employees
WHERE LastName NOT LIKE '[aeiou]%'
```

10. Consulta con todas las ordenes que se hayan realizado en los meses que inicial con vocal

```sql
SELECT DATENAME(MM,OrderDate),*
FROM Orders
WHERE DATENAME(MM,OrderDate) LIKE '[aeiou]%'
```

11. Consulta con los nombre de producto que tengan solamente 3 vocales

```sql
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%[aeiou]%[aeiou]%[aeiou]%' AND ProductName NOT LIKE '%[aeiou]%[aeiou]%[ aeiou]%[aeiou]%'
```

12. Consulta con los fechas de las ordenes cuyo año sea múltiplo de 3

```sql
SELECT OrderDate
FROM Orders
WHERE YEAR(OrderDate)%3=0
```

13. Consulta con las ordenes que se hayan realizado en sábado y domingo, y que hayan sido realizadas por los empleado 1,2y5.

```sql
SELECT OrderID,OrderDate,EmployeeID
FROM Orders
WHERE DATEPART(WEEKDAY,OrderDate) IN  (1,7) AND EmployeeID IN (1,2,5)
```

14. Consulta con las ordenes que no tengan compañía de envío o que se hayan realizado en el mes de enero.

```sql
SELECT *
FROM orders
WHERE ShipVia IS NULL OR DATEPART(mm,orderdate)=1
```

15. Consulta las 10 ultimas ordenes de 1997.

```sql
SELECT Top(10) *
FROM Orders
WHERE YEAR(Orderdate)=1997
ORDER BY(Orderdate) DESC
```

16. Consulta con los 10 productos mas caros del proveedor 1.

```sql
SELECT TOP(10) *
FROM Products
WHERE ProductID=1
ORDER BY (Unitprice) DESC
```

17. Consulta con los 4 empleados con mas antigüedad.

```sql
select top (4) *
from Employees
order by (Hiredate) desc
```

18. Consulta con empleado con una antigüedad de 10,20 o 30 años y con una edad mayor a 30, o con los empleados que vivan en un Blvd. y no tengan una region asignada.

```sql
SELECT *
FROM Employees
WHERE (DATEDIFF(YYYY,HireDate,GETDATE()) IN (10,20,30) AND DATEDIFF(YYYY,BirthDate,GETDATE()) >30) OR
Address LIKE 'blvd%' AND Region IS NULL
```

19. Consulta con las ordenes el código postal de envío tenga solamente letras.

```sql
SELECT *
FROM Orders
WHERE ShipPostalCode NOT LIKE '%[^a-z]%'
```

20. Consulta con las ordenes que se hayan realizado en 1996 y en los meses que inicien con vocal de ese año.

```sql
SELECT *
FROM Orders
WHERE YEAR(OrderDate)=1996 AND DATENAME(MM,OrderDate) LIKE '[aeiou]%'
```

---

### EJERCICIOS B)

1. Seleccionar todos los campos de la tabla clientes, ordenado por nombre del contacto de la compañía, alfabéticamente

```sql
SELECT * FROM Customers
ORDER BY ContactName ASC
```

2. Seleccionar todos los campos de la tabla órdenes, ordenados por fecha de la orden, descendentemente

```sql
SELECT * FROM Orders
ORDER BY OrderDate DESC
```

3. Seleccionar todos los campos de la tabla detalle de la orden, ordenada por cantidad pedida, ascendentemente

```sql
SELECT * --, RealPrice = (Quantity * (UnitPrice * (1 -Discount)))
FROM [Order Details]
ORDER BY Quantity * (UnitPrice * (1 -Discount)) ASC
```

4. Obtener todos los productos, cuyo nombre comienzan con la letra P y tienen un precio unitario comprendido entre 10 y 120

```sql
SELECT * FROM Products
WHERE ProductName LIKE 'p%' AND
UnitPrice BETWEEN 10 AND 120
```

5. Obtener todos los clientes de los países de: USA, Francia y UK

```sql
SELECT * FROM Customers
WHERE Country IN ('USA','France','UK')
```

6. Obtener todos los productos descontinuados y sin stock, que pertenecen a las categorías 1, 3, 4 y 7.

```sql
SELECT * FROM Products
WHERE (Discontinued = 1 OR UnitsInStock = 0) AND CategoryID IN (1,3,4,7)

```

7. Obtener todas las ordenes hechas por el empleado con código: 2, 5 y 7 en el año 1996

```sql
SELECT * FROM Orders
WHERE EmployeeID IN (2,5,7) AND YEAR(OrderDate) = 1996

```

8. Seleccionar todos los clientes que cuenten con FAX

```sql
SELECT * FROM Customers
WHERE Fax IS NOT NULL
```

9. Seleccionar todos los clientes que no cuenten con FAX, del país de USA

```sql
SELECT * FROM Customers
WHERE Country = 'USA' AND Fax IS NOT NULL
```

10. Seleccionar todos los empleados que cuentan con un jefe

```sql
SELECT * FROM Employees
WHERE ReportsTo IS NOT NULL
```

11. Seleccionar todos los campos del cliente, cuya compañía empiece con la letra de A hasta la D y pertenezcan al país de USA, ordenarlos por la dirección

```sql
SELECT * FROM Customers
WHERE  CompanyName LIKE '[a-d]%' AND Country = 'USA'
ORDER BY Address ASC
```

12. Seleccionar todos los campos del proveedor, cuya compañía no comience con las letras de la B a la G, y pertenezca al país de UK, ordenarlos por nombre de la compañía

```sql
SELECT * FROM Suppliers
WHERE CompanyName NOT LIKE '[B-G]%' AND Country = 'UK'
ORDER BY CompanyName ASC
```

13. Seleccionar los productos vigentes cuyos precios unitarios están entre 35 y 250, sin stock en almacen. Pertenecientes a las categorías 1, 3, 4, 7 y 8 que son distribuidos por los proveedores 2, 4, 6, 7 y 9

```sql
SELECT * FROM Products
WHERE (UnitPrice BETWEEN 35 AND 250) AND
CategoryID IN (1,3,4,7,8) AND
SupplierID IN (2,4,6,7,9)
```

14. Seleccionar todos los campos de los productos descontinuados, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, que tengan stock en almacén, y al mismo tiempo que sus precios unitarios están entre 39 y 190, ordenados por código de proveedor y precio unitario de manera ascendente

```sql
SELECT * FROM Products
WHERE SupplierID IN (1,3,7,8,9) AND
UnitsInStock > 0 AND
UnitPrice BETWEEN 39 AND 190
ORDER BY SupplierID ASC, UnitPrice ASC
```

15. Seleccionar los 7 productos con precios más caros, que cuenten con stock en almacén

```sql
SELECT TOP 7 * FROM Products
WHERE UnitsInStock > 0
ORDER BY UnitPrice DESC
```

16. Seleccionar los 9 productos, con menos stock en almacán, que pertenezcan a la categoría 3, 5 y 8

```sql
SELECT TOP 9 * FROM Products
WHERE CategoryID IN (3,5,8)
ORDER BY UnitsInStock ASC
```

17. Seleccionar las órdenes de compra, realizadas por el empleado con código entre el 2 y el 5, además de los clientes con códigos que comienzan con las letras de la A hasta la G, del 31 de Julio de cualquier año

```sql
SELECT * FROM Orders
WHERE EmployeeID IN (2,5) AND
CustomerID LIKE '[A-G]%' AND
DAY(OrderDate) = 31 AND
MONTH(OrderDate) = 1
```

18. Seleccionar las órdenes de compra, realizadas por el empleado con código 3, de cualquier añoo pero solo de los últimos 5 meses (Agosto - Diciembre)

```sql
SELECT *, MONTH(OrderDate) FROM Orders
WHERE EmployeeID = 3 AND MONTH(OrderDate) BETWEEN 8 AND 12
```

19. Seleccionar los detalles de las órdenes de compra, que tengan un monto de cantidad pedida entre 10 y 250

```sql
SELECT *, Discount * UnitPrice * Discount FROM [Order Details]
WHERE (Discount * UnitPrice * Discount) BETWEEN 10 AND 250
```

---

### EJERCICIOS C)

1. El codigo de la orden de compra, la fecha de la orden de compra, el codigo del producto,el nombre del producto y la cantidad pedida

```sql
SELECT od.OrderID, o.OrderDate, p.ProductID, p.ProductName, od.Quantity
FROM [Order Details] AS od
INNER JOIN Products AS p ON od.ProductID = p.ProductID
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
```

2. Mostrar: código de la categoría, el nombre de la categoría, cod. Producto, nombre del producto y precio

```sql
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
```

3. Mostrar: número de la orden, fecha de la orden, código del producto, cantidad, precio y flete de la orden

```sql
SELECT od.OrderID, o.OrderDate, od.ProductID, od.Quantity, od.UnitPrice, o.Freight
FROM [Order Details] AS od
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
```

4. Mostrar: código, nombre, ciudad y país de proveedor, código, nombre, precio, stock del producto

```sql
SELECT s.SupplierID, s.CompanyName, s.City, s.Country, p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Products AS p
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
```

5. Mostrar: código y nombre de la categoría, código, nombre, precio y stock de los productos, código, nombre de los proveedores

```sql
SELECT c.CategoryID, C.CategoryName, p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, s.SupplierID, s.CompanyName
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers AS s ON s.SupplierID = p.SupplierID
```

6. Mostrar: núm. y fecha de la orden, nombre del producto, nombre de la categoría, nombre del proveedor

```sql
SELECT od.OrderID, o.OrderDate, p.ProductName, c.CategoryName, s.CompanyName
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN [Order Details] AS od ON p.ProductID = od.ProductID
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
INNER JOIN Suppliers AS s ON s.SupplierID = p.SupplierID
```

7. Mostrar: núm. y fecha de la orden, nombre y dirección del cliente, nombre y apellidos del empleado. Nombre del producto comprado y nombre del proveedor

```sql
SELECT o.OrderID, o.OrderDate,CustCompanyName = c.CompanyName, c.Address, e.FirstName, e.LastName, p.ProductName,SupplierCompanyName = s.CompanyName
FROM [Order Details] AS od
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
INNER JOIN Employees AS e ON o.EmployeeID = e.EmployeeID
INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
INNER JOIN Products AS p ON p.ProductID = od.ProductID
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
```

8. Modificar el ejercicio 2: solo de los productos de la categorías 2, 4, 5, 7

```sql
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID IN (2,4,5,7)
```

9. Modificar el ejercicio 3 solo las Órdenes del mes de enero de 1997

```sql
SELECT od.OrderID, o.OrderDate,  p.ProductID, p.QuantityPerUnit, p.UnitPrice, o.Freight
FROM [Order Details] AS od
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
INNER JOIN Products AS p ON p.ProductID = od.ProductID
WHERE YEAR(OrderDate) = 1997
```

10. Modificar el ejercicio 4 solo las productos con stock cero

```sql
SELECT s.SupplierID, s.CompanyName, s.City,s.Country, p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Products AS p
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE UnitsInStock = 0
```

11. Modificar el ejercicio 5 solo con precios entre 50 y 100

```sql
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, s.SupplierID, s.CompanyName
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE p.UnitPrice BETWEEN 50 AND 100
```

12. Modificar el ejercicio 6 solo del primer trimestre del año 1996

```sql
SELECT od.OrderID, o.OrderDate, p.ProductName, c.CategoryName, s.CompanyName
FROM [Order Details] AS od
INNER JOIN Products AS p ON od.ProductID = p.ProductID
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
WHERE MONTH(o.OrderDate) <= 3 AND YEAR(o.OrderDate) = 1996
```

---

### EJERCICIOS D)

EJERCICIOS D)

1. Visualizar el máximo y el mínimo precio de los productos por categoría, mostrar el nombre de la categoría

2. Visualizar el máximo y mínimo precio de los productos por proveedor, mostrar el nombre de la compañía proveedora

3. Seleccionar las categorías que tengan más de 5 productos. Mostrar el nombre de la categoría y el número de productos

4. Calcular cuántos clientes existe en cada país

5. Calcular cuántos clientes existen en cada ciudad

6. Calcular el stock total de los productos por cada categoría. Mostrar el nombre de la categoría y el stock por categoría

7. Calcular el stock total de los productos por cada categoría. Mostrar el nombre de la categoría y el stock por categoría. Solamente las categorías `2`, `5` y `8`

8. Obtener el nombre del cliente, nombre del proveedor, nombre del empleado y el nombre de los productos que están en la orden `10250`

9. Mostrar el número de órdenes realizadas de cada uno de los clientes por año

10. Mostrar el número de órdenes realizadas de cada uno de los empleados en cada año

11. Mostrar el número de órdenes realizadas de cada uno de los clientes por cada mes y año
