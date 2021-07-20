USE Northwind
GO
-- FUNCIONES
-- 1. Función que reciba la clave del empleado y regrese los nombres de sus jefes en el árbol de jerarquías
CREATE FUNCTION Dbo.Jefes(@emp INT)
RETURNS VARCHAR(150)
AS
BEGIN
	DECLARE @Jefe INT, @R VARCHAR(150)
	SELECT @Jefe = ReportsTo FROM Employees WHERE EmployeeID = @emp
	SELECT @R = FirstName + ' ' FROM Employees WHERE EmployeeID = @emp

	IF @Jefe IS NOT NULL
	BEGIN
		SELECT @R += dbo.Jefes(@Jefe)
	END
RETURN @R
END
GO
-- EJECUCIÓN
SELECT EmployeeID, FirstName, ReportsTo FROM Employees ORDER BY ReportsTo ASC
GO
SELECT FirstName, JefesArbol = dbo.Jefes(EmployeeID)
FROM dbo.Employees
GO
-- 2. Función que reciba la clave del empleado y regrese el nivel del empleado en el árbol de jerarquías
CREATE FUNCTION Dbo.NivelEmp(@emp INT)
RETURNS INT
AS
BEGIN
	DECLARE @Jefe INT, @R INT= 0
	SELECT @Jefe = ReportsTo FROM Employees WHERE EmployeeID = @emp

	IF @Jefe IS NOT  NULL
		SELECT @R = dbo.NivelEmp(@Jefe)+1
RETURN @R
END
GO
-- EJECUCIÓN
SELECT Employee = e.FirstName,Nivel = dbo.NivelEmp(e.EmployeeID), Boss = j.FirstName
FROM dbo.Employees e
INNER JOIN Employees j ON j.EmployeeID = e.ReportsTo
ORDER BY Nivel ASC
GO
-- 3. Funcion tabla en linea que reciba el folio de una orden y regrese el nombre del producto vendido y el importe total
CREATE FUNCTION DBO.NPRODIMPORTE( @NORDEN INT)
RETURNS @TABLE1 TABLE(NPROD VARCHAR(MAX), IMPORTE NUMERIC(12,2))
BEGIN
	INSERT INTO @TABLE1
	SELECT P.ProductID, Quantity*OD.UnitPrice FROM [Order Details] OD
	INNER JOIN Products P ON P.ProductID = OD.ProductID
	WHERE OD.OrderID = @NORDEN
RETURN
END
GO
-- EJECUCIÓN
SELECT * FROM DBO.NPRODIMPORTE(10248)
GO
-- 4. Funcion multisentencia sin parametro que ingrese el nombre del territorio y los nombres de los empleados que atienden:
--| Territorio | NombresEmpleados |
--|------------|------------------|
CREATE FUNCTION DBO.TERREMPLEADOS()
RETURNS @TABLE TABLE(TERRITORIO VARCHAR(MAX), EMPLEADOS VARCHAR(MAX))
BEGIN
	INSERT INTO @TABLE
	SELECT T.TerritoryDescription, (E.FirstName + E.LastName) FROM EmployeeTerritories ET
	INNER JOIN Employees E ON E.EmployeeID = ET.EmployeeID
	INNER JOIN Territories T ON ET.TerritoryID = T.TerritoryID
RETURN
END
GO
-- EJECUCIÓN
SELECT * FROM DBO.TERREMPLEADOS()
GO
-- 5. Funcion escalar que reciba la clave de una categoria y regresa el total de piezas vendidas.
CREATE FUNCTION dbo.TotalPiezas(@clave int)
RETURNS INT
AS
BEGIN
    DECLARE @total INT
    SELECT @total=SUM(od.Quantity)
    FROM Categories c
    INNER JOIN products p ON c.CategoryID = p.CategoryID
    INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
    WHERE c.CategoryID=@clave
    RETURN @total
END
GO
--EJECUCIÓN
SELECT dbo.TotalPiezas(2)
GO
-- 6. Funcion de tabla en linea que reciba la clave del proveedor y regrese el nombre del producto que surte y el importe total de ventas de dichos productos.
CREATE FUNCTION DBO.ImporteProductosProv(@PROV INT)
RETURNS TABLE
AS
	RETURN (SELECT P.ProductName, IMPORTE = SUM(Quantity*OD.UnitPrice)
			FROM Products P
			INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
			INNER JOIN [Order Details] OD ON OD.ProductID = P.ProductID
			WHERE S.SupplierID = @PROV
			GROUP BY P.ProductName
			)
GO
--EJECUCIÓN
SELECT * FROM dbo.ImporteProductosProv(5)
GO
-- 7. Funcion de tabla de multisentencia (Sin parametros), que regrese una tabla con el folio de la orden y los nombres de los productos que se vendieron.
--| Folio | Productos             |
--| ---   | -------------------   |
--| 100   | Leche, Limón, Jabón   |

CREATE FUNCTION dbo.FolioProductoVend()
RETURNS @datos table(Folio int,Productos varchar(500))
AS
BEGIN
DECLARE @id INT,@nombrep VARCHAR(50),@prods VARCHAR(500),@prod INT
SELECT @id=min(orderid) FROM orders

WHILE @id IS NOT NULL
BEGIN
	SELECT @prod=min(productid) FROM products
	SELECT @prods=''
	WHILE @prod IS NOT NULL
	BEGIN
		SELECT @prods=@prods+p.ProductName+',' 
		FROM Products p 
		INNER JOIN [Order Details] od ON p.ProductID=od.ProductID 
		WHERE od.ProductID=@prod AND od.OrderID=@id

		SELECT @prod=min(productid)
		FROM products 
		WHERE ProductID>@prod
	END
	IF len(@prods)>0
        SET @prods=substring(@prods,1,len(@prods)-1)
	INSERT @datos
	VALUES(@id,@prods)
	SELECT @id=min(orderid) FROM orders WHERE OrderID>@id
END
RETURN
END
GO
--EJECUCIÓN
SELECT * FROM dbo.FolioProductoVend()
ORDER BY LEN(Productos) DESC
GO

-- 8. FUNCION QUE RECIBA LA CLAVE DEL EMPLEADO Y REGRESE UNA CADENA CON LOS NOMBRE DE LOS TERRITORIOS QUE ATIENDE.
CREATE FUNCTION DBO.TERRITORIOSEMP(@EMP INT)
RETURNS VARCHAR(MAX)
BEGIN
	DECLARE @TERRITORIOS VARCHAR(MAX) = ''

	SELECT @TERRITORIOS += ' ,' +RTRIM(T.TerritoryDescription)
	FROM EmployeeTerritories ET
	INNER JOIN Territories T ON ET.TerritoryID = T.TerritoryID
	INNER JOIN Employees E ON E.EmployeeID = ET.EmployeeID
	WHERE E.EmployeeID = @EMP
	IF LEN(@TERRITORIOS) > 0
		SELECT @TERRITORIOS = SUBSTRING(@TERRITORIOS, 3, LEN(@TERRITORIOS))
	RETURN @TERRITORIOS
END
GO
--EJECUCIÓN
SELECT dbo.TERRITORIOSEMP(1)
GO
-- 9. FUNCION ESCALAR QUE RECIBA LA CLAVE DE LA CATEGORIA  Y REGRESE EL TOTAL DE PIEZAS VENDIDAS DE DICHA CATEGORIA.
CREATE FUNCTION DBO.FN_CATVENTAS(@CATID INT)
RETURNS INT
BEGIN
	DECLARE @VENTAS INT = 0
	SELECT @VENTAS += Quantity
	FROM [Order Details] OD
	INNER JOIN Products P ON OD.ProductID = P.ProductID
	INNER JOIN Categories C ON C.CategoryID = P.CategoryID
	WHERE C.CategoryID = @CATID

	RETURN @VENTAS
END
GO
-- EJECUCIÓN
SELECT DBO.CATVENTAS(1)
-- 10. FUNCION QUE RECIBA LA CLAVE DEL EMPLEADO Y REGRESE LA CLAVE DE LA ORDEN CON EL MAYOR IMPORTE.
GO
CREATE FUNCTION DBO.FN_OrdenMayor(@EMP INT)
RETURNS INT
BEGIN
	DECLARE @CLAVE INT = 0
	DECLARE @TABLE TABLE(ID INT, VENTA NUMERIC(12,2))

	INSERT INTO @TABLE
	SELECT TOP 1 O.OrderID, SUM(OD.UnitPrice*OD.Quantity)
	FROM [Order Details] OD
	INNER JOIN Orders O ON O.OrderID = OD.OrderID
	INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
	WHERE E.EmployeeID = @EMP
	GROUP BY O.OrderID
	ORDER BY SUM(OD.UnitPrice*OD.Quantity) DESC

	SELECT @CLAVE = ID FROM @TABLE
	RETURN @CLAVE
END
GO
-- EJECUCIÓN
SELECT DBO.FN_OrdenMayor(1)
-- 11. FUNCION DE  TABLA EN LINEA QUE RECIBA LA CLAVE DEL EMPLEADO Y AÑO, REGRESE EN UNA CONSULTA EL NOMBRE DEL PRODUCTO Y TOTAL DE PRODUCTOS COMPRADOS POR ESE EMPLEADO Y ESE AÑO.
CREATE FUNCTION DBO.FN_PRODUCTOSAÑO(@EMPID INT, @AÑO INT)
RETURNS TABLE
AS
	RETURN (SELECT P.ProductName,VENTAS = SUM(Quantity) FROM Products P 
			INNER JOIN [Order Details] OD ON OD.ProductID = P.ProductID
			INNER JOIN Orders O ON OD.OrderID = O.OrderID
			INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
			WHERE E.EmployeeID = @EMPID AND YEAR(O.OrderDate) = @AÑO
			GROUP BY P.ProductName
			)
GO
-- EJECUCIÓN
SELECT * FROM DBO.FN_PRODUCTOSAÑO(1,1996)
-- 12. UTILIZANDO LA FUNCION ANTERIOR MOSTRAR UNA CONSULTA SIGUIENTE:
--| NOMPROD | TOTAL PIEZAS 96 | TOTAL PIEZAS 97 | TOTAL PIEZAS 98 |
--|---------|-----------------|-----------------|-----------------|
CREATE FUNCTION DBO.FN_TODOSPRODAÑOS(@EMP INT)
RETURNS TABLE
AS
	RETURN(
			SELECT P.ProductName, ISNULL(P1.VENTAS,0) 'TOTAL PIEZAS 96', 
			ISNULL(P2.VENTAS,0) 'TOTAL PIEZAS 97', ISNULL(P3.VENTAS,0) 'TOTAL PIEZAS 98'
			FROM Products P
			LEFT JOIN DBO.FN_PRODUCTOSAÑO(@EMP,1996) P1 ON P1.ProductName = P.ProductName
			LEFT JOIN DBO.FN_PRODUCTOSAÑO(@EMP,1997) P2 ON P2.ProductName = P.ProductName
			LEFT JOIN DBO.FN_PRODUCTOSAÑO(@EMP,1998) P3 ON P3.ProductName = P.ProductName
		  )
GO
-- EJECUCIÓN
SELECT * FROM DBO.FN_TODOSPRODAÑOS(2)
-- 13. FUNCION DE TABLA DE MUTISENTENCIA (SIN PARAMETROS DE ENTRADA) QUE REGRESE UNA TABLA CON EL FOLIO DE LA ORDEN Y LOS NOMBRES DE LOS PRODUCTOS QUE SURTE.
--| ORDERID | NOMPROD | 
--|---------|-----------------|
GO
CREATE FUNCTION DBO.FN_FolioNombres()
RETURNS @TABLA TABLE(ORDERID INT, NOMBRE VARCHAR(MAX))
BEGIN
	DECLARE @ORDERID int, @PRODID int, @PRODNAMES VARCHAR(MAX)
	SELECT @ORDERID = MIN(OrderID) FROM [Order Details]
	WHILE @ORDERID IS NOT NULL
	BEGIN
		SELECT @PRODNAMES = ''

		SELECT @PRODNAMES+= ProductName+', '
		FROM Products P
		INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
		WHERE @ORDERID = OD.OrderID
		IF LEN(@PRODNAMES) > 0
			SELECT @PRODNAMES = SUBSTRING(@PRODNAMES,1,LEN(@PRODNAMES)-1)
		INSERT INTO @TABLA VALUES(@ORDERID, @PRODNAMES)
		SELECT @ORDERID = MIN(OrderID) FROM [Order Details] WHERE OrderID > @ORDERID
	END
	RETURN
END
GO
-- EJECUCIÓN
SELECT * FROM DBO.FN_FolioNombres()