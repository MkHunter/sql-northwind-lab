# SQL Homework 6 - VISTAS TRANSACTSQL

Created By: Miguel López
DATE: October 6, 2018 12:43 PM
Tested ON: Miscrosoft SQL Server 2017

---

## INSTRUCCIONES

UTILIZANDO TRANSACTSQL(TABLAS Y VARIABLES TEMPORALES) REALIZAR LA CONSULTA PARA OBTENER LA EDAD DE LOS EMPLEADOS CON EL SIGUIENTE FORMATO:

[data/images/TransactSQL.png](data/images/TransactSQL.png)

---

## CREACIÓN DE TABLAS

```sql
CREATE TABLE #tabla (Empleados INT, Edad VARCHAR(50))
DECLARE @empleado INT, @fecha DATE, @Birthdate DATE, @contadorDD INT, @contadorMM INT, @contadorYY INT
SELECT @empleado = MIN(EmployeeID) FROM Employees
WHILE (@empleado IS NOT NULL)
	BEGIN
		SELECT @fecha = BirthDate FROM Employees
		WHERE EmployeeID = @empleado
		SELECT @Birthdate = BirthDate FROM Employees
		WHERE EmployeeID = @empleado
		SELECT @contadorDD = 0, @contadorMM = 0, @contadorYY = 0
		WHILE (@fecha <= GETDATE())
			BEGIN
				SELECT @fecha = DATEADD(dd, 1, @fecha)
				SELECT @contadorDD = @contadorDD + 1
				IF (DATEPART(dd, @Birthdate) = DATEPART(dd, @fecha))
					BEGIN
						SELECT @contadorMM = @contadorMM + 1
						SELECT @contadorDD = 0
					END
				IF (@contadorMM = 12)
					BEGIN
						SELECT @contadorYY = @contadorYY + 1
						SELECT @contadorMM = 0
					END
			END
		INSERT #tabla VALUES (@empleado, CONVERT(VARCHAR(3), @contadorYY) + ' Años, ' +
		CONVERT(VARCHAR(2), @contadorMM) + ' Meses, '+ CONVERT(VARCHAR(2),@contadorDD )+
             ' Días')
		SELECT @empleado = MIN (EmployeeID) FROM Employees
		WHERE EmployeeID > @empleado
	END
```

---

## CONSULTAS

```sql
SELECT * FROM #tabla

SELECT t.Empleados, e.FirstName +' '+ e.LastName AS Nombre, t.Edad
FROM #tabla t
INNER JOIN Employees e ON t.Empleados = e.EmployeeID

SELECT FirstName, BirthDate FROM Employees
```
