CREATE DATABASE Hospitales
GO
USE Hospitales
GO
CREATE TABLE ZONAS(
ZONAID INT NOT NULL,
NOMBRE VARCHAR (50) NOT NULL
)

CREATE TABLE HOSPITALES(
HOSPID INT NOT NULL,
NOMBRE VARCHAR(50) NOT NULL,
ZONAID INT NOT NULL
)

CREATE TABLE CONSULTORIOS(
CONID INT NOT NULL,
NOMBRE VARCHAR(50) NOT NULL,
HOSPID INT NOT NULL
)

CREATE TABLE CITAS(
CITA INT NOT NULL,
FECHA DATETIME NOT NULL,
PESO DECIMAL(5,2) NOT NULL,
ESTATURA DECIMAL (3,2) NOT NULL,
PRESION DECIMAL (5,2) NOT NULL,
OBSERVACIONES VARCHAR(300) NOT NULL,
CONID INT NOT NULL
)
GO
-- PRIMARY KEY
ALTER TABLE ZONAS ADD CONSTRAINT PK_ZONAS PRIMARY KEY (ZONAID)

ALTER TABLE HOSPITALES ADD CONSTRAINT PK_HOSPITALES PRIMARY KEY(HOSPID)

ALTER TABLE CONSULTORIOS ADD CONSTRAINT PK_COSULTORIOS PRIMARY KEY(CONID)

ALTER TABLE CITAS ADD CONSTRAINT PK_CITAS PRIMARY KEY(CITA)
GO
-- FOREIGN KEY
ALTER TABLE HOSPITALES ADD CONSTRAINT FK_HOSPITALES_ZOANAS FOREIGN KEY (ZONAID)
REFERENCES ZONAS(ZONAID)

ALTER TABLE CONSULTORIOS ADD CONSTRAINT FK_CONSULTORIOS_HOSPITALES FOREIGN KEY(HOSPID)
REFERENCES HOSPITALES(HOSPID)

ALTER TABLE CITAS ADD CONSTRAINT FK_CITAS_CONSULTORIO FOREIGN KEY(CONID)
REFERENCES CONSULTORIOS (CONID)
GO
-- CHECK CONSTRAINT
ALTER TABLE CITAS ADD CONSTRAINT CC_CITA_PESO CHECK (PESO>0),
CONSTRAINT CC_CITA_ESTATURA CHECK(ESTATURA>0),CONSTRAINT CC_CITA_PRESION CHECK(PRESION>0)
GO
-- DEFAULT CONSTRAINT
ALTER TABLE CITAS ADD CONSTRAINT DF_CITA_OBSERVACION DEFAULT ('EL PACIENTE TIENE GRIPA') FOR OBSERVACIONES
GO
-- INSERTAR DATOS
INSERT INTO Zonas(Zonaid,Nombre)
VALUES (1,'Norte'),(2,'Sur'),(3,'Este'),(4,'Oeste'),(5,'Centro')
INSERT INTO Hospitales(Hospid,Nombre,Zonaid)
VALUES (1,'Hospital de la Mujer',1),(2,'IMSS',2),(3,'ISSTE',3),(4,'Hospital los Angeles',4),(5,'Particular',5),
(6,'Hospital de la Mujer',1)
INSERT INTO Consultorios(Conid,Nombre,Hospid)
VALUES (1,'Dermatologia',1),(2,'Pediatria',2),(3,'General',3),(4,'Cardiologia',4),(5,'Radiologia',5),(6,'Alergologia',1)
INSERT INTO Citas(Cita,Fecha,Peso,Estatura,Presion,Observaciones,Conid)
VALUES (1,'01-01-2017 11:20:00.12',70.543,1.70,150,DEFAULT,1),
(2,'02-01-2017 12:35:18.12',60.453,1.64,160,DEFAULT,2),
(3,'02-01-2017 15:12:20.23',80.172,1.80,158,DEFAULT,3),
(4,'03-01-2018 17:14:10.43',90.120,1.86,170,DEFAULT,4),
(5,'04-01-2018 10:02:52.31',50.725,1.54,161,DEFAULT,5),
(6,'04-01-2018 10:02:52.31',50.725,1.54,161,DEFAULT,5),
(7,'04-01-2018 10:02:52.31',82.156,1.91,159,DEFAULT,5)
GO
-- CREACI??N DE LAS VISTAS
CREATE VIEW VW_HOSPITALES AS
SELECT H.HOSPID,H.NOMBRE,Z.ZONAID,ZONANOMBRE=Z.NOMBRE
FROM HOSPITALES H
INNER JOIN ZONAS Z ON Z.ZONAID=H.ZONAID
GO
CREATE VIEW VW_CONSULTORIOS AS
SELECT C.CONID,C.NOMBRE,H.HOSPID,HOSPNOMBRE=H.NOMBRE,H.ZONAID,H.ZONANOMBRE
FROM CONSULTORIOS C
INNER JOIN VW_HOSPITALES H ON C.HOSPID=H.HOSPID
GO
CREATE VIEW VW_CITAS AS
SELECT C.CITA,C.FECHA,C.PESO,C.ESTATURA,C.PRESION,C.OBSERVACIONES, CN.CONID,CONNOMBRE=CN.NOMBRE,CN.HOSPID,CN.HOSPNOMBRE,CN.ZONAID,CN.ZONANOMBRE
FROM  CITAS C
INNER JOIN VW_CONSULTORIOS CN ON C.CONID=CN.CONID
GO
-- CONSULTAS
-- 1. NOMBRE DE LA ZONA Y TOTAL DE HOSPITALES DE LA ZONA.
SELECT ZONANOMBRE,[TOTAL DE HOSPITALES]=COUNT(*)
FROM VW_HOSPITALES
GROUP BY ZONANOMBRE
-- 2. NOMBRE DEL CONSULTORIO Y TOTAL DE CITAS REALIZADAS.
SELECT ZONANOMBRE,[TOTAL DE HOSPITALES]=COUNT(*)
FROM VW_HOSPITALES
GROUP BY ZONANOMBRE
-- 3. A??O Y TOTAL DE CITAS REALIZADAS.
SELECT A??O=YEAR(FECHA),[CITAS REALIZADAS]=COUNT (*)
FROM VW_CITAS
GROUP BY YEAR(FECHA)
-- 4. NOMBRE DE LA ZONA Y TOTAL DE CITAS REALIZADAS
SELECT ZONANOMBRE,COUNT(DISTINCT CITA )
FROM VW_CITAS
GROUP BY ZONANOMBRE
-- 5. NOMBRE DEL HOSPITAL Y TOTAL DE CONSULTORIOS QUE CONTIENE
SELECT HOSPNOMBRE,COUNT(DISTINCT CONID)
FROM VW_CONSULTORIOS
GROUP BY HOSPNOMBRE
-- 6. NOMBRE DEL CONSULTORIO Y PESO TOTAL DE LOS PACIENTES ATENDIDOS EN LAS CITAS.
SELECT CONNOMBRE,[PESO TOTAL]=SUM(PESO)
FROM VW_CITAS
GROUP BY(CONNOMBRE)
-- 7. HOSPITAL Y TOTAL DE CITAS REALIZADAS POR MES DEL A??O 2017.
SELECT HOSPNOMBRE,
ENERO=COUNT(CASE WHEN MONTH(FECHA)=1 THEN CITA END),
FEBRERO=COUNT(CASE WHEN MONTH(FECHA)=2 THEN CITA END),
MARZO=COUNT(CASE WHEN MONTH(FECHA)=3 THEN CITA END),
ABRIL=COUNT(CASE WHEN MONTH(FECHA)=4 THEN CITA END),
MAYO=COUNT(CASE WHEN MONTH(FECHA)=5 THEN CITA END),
JUNIO=COUNT(CASE WHEN MONTH(FECHA)=6 THEN CITA END),
JULIO=COUNT(CASE WHEN MONTH(FECHA)=7 THEN CITA END),
AGOSTO=COUNT(CASE WHEN MONTH(FECHA)=8 THEN CITA END),
SEPTIEMBRE=COUNT(CASE WHEN MONTH(FECHA)=9 THEN CITA END),
OCTUBRE=COUNT(CASE WHEN MONTH(FECHA)=10 THEN CITA END),
NOVIEMBRE=COUNT(CASE WHEN MONTH(FECHA)=11 THEN CITA END),
DICIEMBRE=COUNT(CASE WHEN MONTH(FECHA)=12 THEN CITA END)
FROM VW_CITAS
WHERE YEAR(FECHA)=2017
GROUP BY(HOSPNOMBRE)
