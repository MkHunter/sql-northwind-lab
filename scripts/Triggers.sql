USE Northwind
GO
-- 1.- Utilizando trigger, validar que solo se vendan ordenes de lunes a viernes.
CREATE TRIGGER TR_ORDERS_HABILES_INS
ON ORDERS FOR INSERT AS
	DECLARE @DW INT = 0
	SELECT @DW = DATEPART(DW,OrderDate) FROM INSERTED
	IF @DW IN (1,7)
	BEGIN
		ROLLBACK TRAN
		RAISEERROR(SELECT 'DIA DE LA SEMANA NO HÁBIL')
	END
GO
INSERT INTO Orders VALUES('VINET',1,'2018-11-11','1996-08-01','1996-08-01',1,10,'Hanari Carnes', 'Luisenstr. 48', 'Lyon',null,51100,'France')
GO
-- 2.- Validar que no se vendan mas de 20 ordenes por empleado en una semana.
CREATE TRIGGER TR_ORDERS_LIMWEEK_INS
ON ORDERS FOR INSERT AS
	DECLARE @MORDER DATETIME, @ORDWEEK INT = 0
	SELECT @MORDER = MAX(OrderDate) FROM Orders

	SELECT @ORDWEEK = COUNT(*)
	FROM Orders
	WHERE DATEPART(MM,@MORDER) = DATEPART(MM,OrderDate) AND YEAR(@MORDER) = YEAR(OrderDate)

	IF @ORDWEEK > 20
	BEGIN
		ROLLBACK TRAN
		RAISEERROR(SELECT 'NÚMERO DE ORDENES POR SEMANA EXCEDIDO')
	END
GO
INSERT INTO Orders VALUES('VINET',1,'1998-05-06','1996-08-01','1996-08-01',1,10,'Hanari Carnes', 'Luisenstr. 48', 'Lyon',null,51100,'France')
GO
-- 3.- Validar que el campo firstname en la tabla employees solamente tenga nombres que inicien con vocal.
CREATE TRIGGER TR_EMPLOYEES_VOCAL_INS
ON EMPLOYEES FOR INSERT AS
	DECLARE @FN VARCHAR = ''
	SELECT @FN = FirstName FROM INSERTED

	IF @FN NOT LIKE '[aeiou]%'
	BEGIN
		ROLLBACK TRAN
		RAISEERROR(SELECT 'NOMBRE DE EMPLEADO NO VÁLIDO, DEBE COMENZAR CON VOCAL')
	END
GO
-- 4.- validar que el importe de venta de  cada orden no sea mayor a $10,000.
CREATE TRIGGER TR_ORDERDETAILS_LIMIMPORT_INS
ON [ORDER DETAILS] FOR INSERT AS
	DECLARE @ORDERID INT
	SELECT @ORDERID = MAX(OrderID) FROM INSERTED
	WHILE @ORDERID IS NOT NULL
	BEGIN
		DECLARE @IMPORTE NUMERIC(12,2) = 0

		SELECT @IMPORTE = SUM(UnitPrice*Quantity) 
		FROM INSERTED
		WHERE OrderID = @ORDERID
		
		IF @IMPORTE > 10000
		BEGIN
			ROLLBACK TRAN
			RAISEERROR(SELECT 'EL IMPORTE TOTAL DE ALGUNA DE LAS ORDENES INSERTADA EXCEDE EL MONTO DE 10,000$')
		END
	END
GO

-- 5.- validar que no  se puedan eliminar ordenes que se hicieron los lunes.
CREATE TRIGGER TR_ORDERS_MONDAY_DEL
ON ORDERS FOR DELETE AS
	DECLARE @DAY INT
	
	SELECT @DAY = DATEPART(DW, OrderDate) FROM DELETED
	IF @DAY IN (2)
	BEGIN
		ROLLBACK TRAN
		RAISEERROR(SELECT 'NO SE PUEDEN ELIMINAR LAS ORDENES DEL DÍA LUNES')
	END
GO
-- 6.- Validar que no se realicen inserciones masivas en la tabla products.
CREATE TRIGGER TR_PRODUCTS_INS_MAS
ON PRODUCTS FOR INSERT AS
	DECLARE @NPRODINSERTED INT

	SELECT @NPRODINSERTED = COUNT(*) FROM INSERTED
	IF @NPRODINSERTED > 1
	BEGIN
		ROLLBACK TRAN
		RAISEERROR(SELECT 'NO SE PUEDEN REALIZAR INSERCIONES MASIVAS EN LA TABLA PRODUCTS')
	END
GO
-- 7.- Validar que no se pueda modificar el campo unitprice de la tabla [order details].
CREATE TRIGGER TR_ORDERDETAILS_UNITPRICE_UPD
ON [ORDER DETAILS] FOR UPDATE AS
	 if UPDATE(UnitPrice)
	 BEGIN
		ROLLBACK TRAN
		RAISEERROR(SELECT 'NO SE PUEDEN REALIZAR INSERCIONES MASIVAS EN LA TABLA PRODUCTS')
	 END
GO
-- 8.- Validar que solo se pueda actualizar una sola vez el nombre del cliente.
ALTER TABLE CUSTOMERS ADD CONTA INT
GO
UPDATE CUSTOMERS SET CONTA = 0
GO
CREATE TRIGGER TR_CUSTOMERS_LIMUPD_UPD
ON CUSTOMERS FOR UPDATE AS
	DECLARE @CLAVE VARCHAR(MAX) = '', @CONTA INT

	SELECT @CLAVE = CustomerID, @CONTA = CONTA FROM INSERTED

	IF UPDATE(CompanyName)
	BEGIN
		IF @CONTA > 0
		BEGIN
			ROLLBACK TRAN
			RAISEERROR(SELECT 'NO SE PUEDEN ACTUALIZAR EL NOMBRE DEL CLIENTE MÁS DE UNA VEZ')
		END
	END
GO
-- 9.- Validar que no se puedan eliminar categorías que tengan una clave impar.
CREATE TRIGGER TR_CATEGORIES_IDIMPAR_DEL
ON CATEGORIES FOR DELETE AS
	DECLARE @CLAVE INT
	SELECT @CLAVE = CategoryID FROM DELETED
	
	IF @CLAVE % 2 <> 0
	BEGIN
		ROLLBACK TRAN
		RAISEERROR(SELECT 'NO SE PUEDEN ELIMINAR REGISTROS CON CLAVE IMPAR DE LA TABLA CATEGORIAS')
	END
GO


-- 10.- Validar que no se puedan insertar ordenes que se realicen en domingo.
CREATE TRIGGER TR_ORDERS_WEEK_INS
ON ORDERS FOR INSERT AS
	DECLARE @DW INT = 0
	SELECT @DW = DATEPART(DW, OrderDate) FROM ORDERS
	IF @DW IN (1)
	BEGIN
		ROLLBACK TRAN
		RAISEERROR(SELECT 'NO SE PUEDEN REALIZAR INSERCIONES EN LA TABLA ORDERS LOS DÍAS DOMINGO')
	END
GO
