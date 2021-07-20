# SQL Envios

Created By: Miguel López
Date: September 10, 2018 2:19 PM
Tested ON: Miscrosoft SQL Server 2017

---

## INSTRUCCIONES

REPLICA EL SIGUIENTE MODELO DE DATOS:

ENTREGAS:

- [CREACIÓN](#CREACIÓN-DE-TABLAS)
- [LLAVES PRIMARIAS](#LLAVES-PRIMARIAS)
- [LLAVES FORÁNEAS](#LLAVES-FORÁNEAS)
- [INSERTAR DATOS](#INSERTAR-DATOS)
- [VISTAS](#VISTAS)
  - [Sucursales](#Sucursales)
  - [Clientes](#Clientes)
  - [Envios](#Envios)

[Script AQUI](scripts/Envios.sql)

---

## CREACIÓN DE TABLAS

```sql
CREATE DATABASE Envios
GO
USE Envios
GO
CREATE TABLE Sucursales(
SucId int NOT NULL,
SucNombre varchar(30) NOT NULL,
SucDomicilio varchar(30) NOT NULL,
SucTelefono char(10)
)

CREATE TABLE Clientes(
CteId INT NOT NULL,
CteNombre varchar(30) NOT NULL,
CteApellidos varchar(30) NOT NULL,
CteDomicilio varchar(30) NOT NULL,
CteSexo char(1) NOT NULL,
CteRFC char(13) NOT NULL,
Asesor int
)

CREATE TABLE Envios(
SucId INT NOT NULL,
Folio INT NOT NULL,
Fecha datetime NOT NULL,
Importe numeric(10,2) NOT NULL,
Peso numeric(10,2) NOT NULL,
CteId INT NOT NULL
)
```

---

## LLAVES PRIMARIAS

```sql
ALTER TABLE Sucursales ADD CONSTRAINT PK_Sucursales PRIMARY KEY(SucId)

ALTER TABLE Clientes ADD CONSTRAINT PK_Clientes PRIMARY KEY(CteId)

ALTER TABLE Envios ADD CONSTRAINT PK_Envios PRIMARY KEY(SucId,Folio)
```

---

## LLAVES FORÁNEAS

```sql
ALTER TABLE Clientes ADD CONSTRAINT FK_Clientes_Clientes
FOREIGN KEY(Asesor) REFERENCES Clientes(CteId)

ALTER TABLE Envios ADD CONSTRAINT FK_Envios_Clientes
FOREIGN KEY(CteId) REFERENCES Clientes(CteId)

ALTER TABLE Envios ADD CONSTRAINT FK_Envios_Sucursales
FOREIGN KEY(SucId) REFERENCES Sucursales(SucId)
```

---

## INSERTAR DATOS

```sql

```

---

## CONSULTAS

```sql
SELECT * FROM Sucursales;
SELECT * FROM Clientes;
SELECT * FROM Envios;
```

---

## VISTAS

### Asesor

```sql
CREATE VIEW vw_asesor AS
SELECT C.*,AseNombre = A.CteNombre,AseApellidos = A.CteApellidos,AseDomicilio = A.CteDomicilio,
AseSexo = A.CteSexo,AseRFC = A.CteRFC
FROM Clientes A
INNER JOIN Clientes C ON C.CteId = A.Asesor
```

### Envios

```sql
CREATE VIEW vw_envios AS
SELECT E.Folio, E.Fecha, E.Importe, E.Peso, S.SucNombre, S.SucDomicilio, S.SucTelefono, A.* FROM Envios E
INNER JOIN Sucursales S ON E.SucId = S.SucId
INNER JOIN vw_asesor A ON E.CteId = A.CteId
```

```sql
SELECT * FROM vw_asesor
SELECT * FROM vw_envios
```
