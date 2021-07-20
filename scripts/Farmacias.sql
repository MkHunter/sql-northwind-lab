CREATE DATABASE FARMACIAS
GO
USE FARMACIAS
GO
CREATE TABLE Ventas (
	Folio INT NOT NULL,
	Fecha DATE NOT NULL,
	CteId INT NOT NULL,
	FarId SMALLINT NOT NULL,
);
GO
CREATE TABLE Clientes (
	CteId INT NOT NULL,
	CteNombre VARCHAR(50) NOT NULL,
	CteApeMat VARCHAR(50) NULL,
	CteApePat VARCHAR(50) NOT NULL,
	CteDomicilio VARCHAR(50) NOT NULL,
	CteTelefono CHAR(10) NULL,
	ColId INT NOT NULL
);
GO
CREATE TABLE Colonias (
	ColId INT NOT NULL,
	ColNombre VARCHAR(50) NOT NULL
);
GO
CREATE TABLE Medicamentos (
	MedId INT NOT NULL,
	MedNombre VARCHAR(50) NOT NULL,
	MedDescripcion VARCHAR(50) NULL,
	MedPrecio Numeric(12,2) NOT NULL,
	LabId INT NOT NULL,
);
GO
CREATE TABLE Laboratorios (
	LabId INT NOT NULL,
	LabNombre VARCHAR(50) NOT NULL,
	LabDomicilio VARCHAR(50) NOT NULL,
	LabTelefono CHAR(10) NULL,
);
GO
CREATE TABLE Detalle (
	Folio INT NOT NULL,
	MedId INT NOT NULL,
	Cantidad SMALLINT NOT NULL,
	Precio Numeric(12,2) NOT NULL,
);
GO
CREATE TABLE Farmacias (
	FarId SMALLINT NOT NULL,
	FarNombre VARCHAR(50) NOT NULL,
	FarDomocilio VARCHAR(50) NOT NULL,
);
GO
ALTER TABLE Ventas ADD CONSTRAINT PK_VENTAS PRIMARY KEY(Folio);
ALTER TABLE Clientes ADD CONSTRAINT PK_CLIENTES PRIMARY KEY(CteId);
ALTER TABLE Colonias ADD CONSTRAINT PK_COLONIAS PRIMARY KEY(ColId);
ALTER TABLE Medicamentos ADD CONSTRAINT PK_MEDICAMENTOS PRIMARY KEY(MedId);
ALTER TABLE Laboratorios ADD CONSTRAINT PK_LABORATORIOS PRIMARY KEY(LabId);
ALTER TABLE Farmacias ADD CONSTRAINT PK_FARMACIAS PRIMARY KEY(FarId);
GO
ALTER TABLE Ventas ADD CONSTRAINT FK_VENTAS_CLIENTES
FOREIGN KEY(CteId) REFERENCES Clientes(CteId);

ALTER TABLE Ventas ADD CONSTRAINT FK_VENTAS_FARMACIAS
FOREIGN KEY(FarId) REFERENCES Farmacias(FarId);

ALTER TABLE Clientes ADD CONSTRAINT FK_CLIENTES_COLONIAS
FOREIGN KEY(ColId) REFERENCES Colonias(ColId);

ALTER TABLE Detalle ADD CONSTRAINT FK_DETALLE_VENTAS
FOREIGN KEY(Folio) REFERENCES Ventas(Folio);

ALTER TABLE Detalle ADD CONSTRAINT FK_DETALLE_MEDICAMENTOS
FOREIGN KEY(MedId) REFERENCES Medicamentos(MedId);

ALTER TABLE Medicamentos ADD CONSTRAINT FK_MEDICAMENTOS_LABORATORIOS
FOREIGN KEY(LabId) REFERENCES Laboratorios(LabId);
GO
INSERT INTO Laboratorios VALUES
(1,'Lab. Inc', 'AGUSTINA RAMIREZ', 1414369420),
(2,'Laboratorio de Dexter', 'RICON DEL VALLE', 0249634141),
(3,'Laboratorio de Cerebro', 'LAS QUINTAS', 4206943411),
(4,'Laboratorios Barraza', 'VILLA FONTAN', 1143496024),
(5,'Laboratorio de Cerebro', 'BARRANCOS', 6942091190);
GO
INSERT INTO Medicamentos VALUES
(1,'Paracetamol', 'Para cabeza', 69, 1),
(2,'Aids', 'Para el cuerpo', 43, 3),
(3,'Pildoras', 'Para la vida', 777, 2),
(4,'Adrenalina', 'Para ir más rápido', 420, 5),
(5,'Insulina', 'Para no morirte', 911, 4);
GO
INSERT INTO Ventas VALUES
(1,'20180614',3,3),
(2,'20180614',2,5),
(3,'20180615',1,4),
(4,'20180616',4,2),
(5,'20180616',5,1);
GO
INSERT INTO Detalle VALUES
(1,5,1,911),
(2,2,3,129),
(3,3,1,777),
(4,4,2,840),
(5,1,4,276);
GO
INSERT INTO Clientes VALUES
(1,'Ernesto', 'Lagrera','Pucha', 'Stir No. 259', 6672991318, 3),
(2,'Mariem','Bárbara','Padure','Calle Sobrin No. 635',6647997438,4),
(3,'Ariel','Bartlett','Joyce','Boulevard Candea No. 207',6670332392, 1),
(4,'Zacarias','Incio','Mota','Calle Hammu No. 783',6672338549,2),
(5,'Macedonio','Allouchi','Casas','Cerrada Goce No. 85',6651337929,5);
GO
INSERT INTO Colonias VALUES
(1,'LAS QUINTAS'),
(2,'BARRANCOS'),
(3,'LAS TORRES'),
(4,'LAS LOMAS'),
(5,'LA CAMPIÑA');
GO
INSERT INTO Farmacias VALUES
(1,'Farmacia Similares','CALLE CORDILLERA NEGRA 9908'),
(2,'Farmacia Guadalajara','CALLE FRANCISCO I MADERO 405'),
(3,'FarmaciaCon','BLV MARCELINO GARCIA BARRAGAN 2077'),
(4,'Farmacia Emergencias','CLZ LAZARO CARDENAS 2592'),
(5,'Farmacias del Ahorro','AVE BAHIA DE CORONADO 124');
GO
CREATE VIEW vw_medicamentos AS
SELECT L.LabNombre, L.LabDomicilio, L.LabTelefono, M.* FROM Medicamentos M
INNER JOIN Laboratorios L ON M.LabId = M.LabId
GO
CREATE VIEW vw_clientes AS
SELECT C.*, Co.ColNombre FROM Clientes C
INNER JOIN Colonias Co ON C.ColId = Co.ColId
GO
CREATE VIEW vw_ventas AS
SELECT V.Folio, V.Fecha, F.*, C.* FROM Ventas V
INNER JOIN Farmacias F ON V.FarId = F.FarId
INNER JOIN vw_clientes C ON V.CteId = C.CteId
GO
CREATE VIEW vw_detalle AS
SELECT D.Cantidad, D.Precio, V.*, M.* FROM Detalle D
INNER JOIN vw_medicamentos M ON D.MedId = M.MedId
INNER JOIN vw_ventas V ON D.Folio = V.Folio