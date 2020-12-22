DROP TABLE IF EXISTS Horarios;
DROP TABLE IF EXISTS Telefonos;
DROP TABLE IF EXISTS Viveros;

SET timezone = 'America/Costa_Rica';

-- Crear tabla de viveros
CREATE TABLE Viveros(

	idVivero SERIAL NOT NULL PRIMARY KEY,
	nombre varchar NOT NULL UNIQUE,
	direccion varchar NOT NULL,
	
	ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL
);

-- Crear tabla de horariosXvivero

CREATE TABLE Horarios(

	idHorario BIGSERIAL NOT NULL PRIMARY KEY,
	
	-- FK
	idVivero BIGSERIAL NOT NULL,
	
	-- Numero
	horaInicio varchar NOT NULL,
	horaFin varchar NOT NULL,
	-- Dias
	dias varchar NOT NULL UNIQUE,
	
	ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL,
	
	FOREIGN KEY (idvivero)
		REFERENCES Viveros MATCH SIMPLE,
	
	UNIQUE(horaInicio,horaFin)

);

-- Crear tabla de telefonosXvivero
CREATE TABLE Telefonos(
	
	idTelefono BIGSERIAL NOT NULL PRIMARY KEY,
	
	-- FK
	idVivero BIGSERIAL NOT NULL,
	
	-- Numero
	numeroTel varchar NOT NULL UNIQUE,
	
	ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL,
	
	FOREIGN KEY (idvivero)
		REFERENCES Viveros MATCH SIMPLE
	
);

-- Funciones

-- Agregar
CREATE OR REPLACE FUNCTION spAgregarVivero(
	nombreInput varchar,
	direccionInput varchar
)
RETURNS BOOLEAN
AS
$$
	
	DECLARE
		
		idViveroLookup BIGINT := (SELECT V.idVivero FROM Viveros V WHERE LOWER(V.nombre) LIKE LOWER(nombreInput) and V.borrado = FALSE);
		borradoLookup BOOLEAN := (SELECT V.borrado FROM Viveros V WHERE idViveroLookup = V.idVivero);
		
	BEGIN
		
		IF idViveroLookup IS NOT NULL THEN
		
			IF borradoLookup = TRUE THEN 
		
				UPDATE Viveros
					SET
					direccion = direccionInput,
					borrado = FALSE,
					ultimaActualizacion = NOW() WHERE idViveroLookup = Viveros.idVivero;
					
					RETURN TRUE;	
			ELSE 
				
				RETURN FALSE;
				
			END IF;
			
		ELSE
		
			INSERT INTO Viveros (nombre,direccion, ultimaActualizacion,borrado)
			VALUES (nombreInput,direccionInput, NOW(), FALSE);
				
			RETURN TRUE;
		
		END IF;
		
	END;

$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION spAgregarTelefono(
	nombreViveroInput varchar,
	numeroTelefonoInput varchar
)
RETURNS BOOLEAN
AS
$$
	DECLARE 
	
		idViveroLookup BIGINT := (SELECT V.idVivero FROM Viveros V WHERE LOWER(V.nombre) LIKE LOWER(nombreViveroInput) and V.borrado = FALSE);
	
	BEGIN
		IF idViveroLookup IS NOT NULL THEN
		
			INSERT INTO Telefonos(idVivero, numeroTel,ultimaActualizacion,borrado)
			VALUES(idViveroLookup,numeroTelefonoInput,NOW(),FALSE);
			
			RETURN TRUE;
			
		ELSE
			
			RETURN FALSE;
			
		END IF;
		
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION spAgregarHorario(
	nombreViveroInput varchar,
	horaInicioInput varchar,
	horaFinInput varchar,
	diasInput varchar
)
RETURNS BOOLEAN
AS
$$
	DECLARE 
	
		idViveroLookup BIGINT := (SELECT V.idVivero FROM Viveros V WHERE LOWER(V.nombre) LIKE LOWER(nombreViveroInput) and V.borrado = FALSE);
	
	BEGIN
	
		IF idViveroLookup IS NOT NULL THEN
			
			INSERT INTO Horarios (idVivero,horaInicio, horaFin, dias, ultimaActualizacion, borrado)
			VALUES (idViveroLookup,horaInicioInput,horaFinInput, diasInput, NOW(), FALSE);
			
			RETURN TRUE;
			
		ELSE
			
			RETURN FALSE;
			
		END IF;
		
	END;
$$ LANGUAGE PLPGSQL;


-- Listar viveros

CREATE OR REPLACE FUNCTION spListViveros()
RETURNS TABLE(nombre varchar, direccion varchar)
AS
$$
	BEGIN
	
		RETURN QUERY
		SELECT V.nombre, V.direccion FROM Viveros V WHERE V.borrado = FALSE;
		
	END;
$$ LANGUAGE PLPGSQL;


-- Consultar informacion de vivero

CREATE OR REPLACE FUNCTION spGetInfoVivero()
RETURNS TABLE(nombre varchar, direccion varchar)
AS
$$
	DECLARE 
		
		idViveroLookup BIGINT := (SELECT V.idVivero FROM Viveros V WHERE LOWER(V.nombre) LIKE LOWER(nombreViveroInput) and V.borrado = FALSE);
		
	BEGIN
	
		RETURN QUERY
		SELECT V.nombre, V.direccion FROM Viveros V WHERE V.borrado = FALSE;
		
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION spGetHorarioVivero(
	nombreViveroInput varchar
)
RETURNS TABLE(vivero varchar, horaInicio varchar, horaFin varchar, dias varchar)
AS
$$
	DECLARE 
	
		idViveroLookup BIGINT := (SELECT V.idVivero FROM Viveros V WHERE LOWER(V.nombre) LIKE LOWER(nombreViveroInput) and V.borrado = FALSE);
	
	BEGIN
	
		RETURN QUERY
		SELECT V.nombre, H.horaInicio, H.horaFin, H.dias FROM Horarios H JOIN Viveros V on V.idVivero = H.idVivero WHERE H.idVivero = idViveroLookup;
		
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION spGetTelefonosVivero(
	nombreViveroInput varchar
)
RETURNS TABLE(vivero varchar, telefono varchar)
AS
$$
	DECLARE 
	
		idViveroLookup BIGINT := (SELECT V.idVivero FROM Viveros V WHERE LOWER(V.nombre) LIKE LOWER(nombreViveroInput) and V.borrado = FALSE);
	BEGIN
	
		RETURN QUERY
		SELECT V.nombre,T.numeroTel FROM Telefonos T JOIN Viveros V on V.idVivero = T.idVivero WHERE T.idVivero = idViveroLookup;
		
	END;
$$ LANGUAGE PLPGSQL;

/*
SELECT spAgregarVivero('FUNDAZOO','Calle Ross De la Cruz Roja de Santa Ana 300 metros oeste y 200 metros norte, San José, Santa Ana') as success;
SELECT spAgregarTelefono('FUNDAZOO','2282 8434') as success;
SELECT spAgregarHorario('FUNDAZOO','8:00','15:30','Lunes - Viernes') as success;
SELECT spAgregarHorario('FUNDAZOO','9:00','16:30','Sábados y domingos') as success;

SELECT * from spGetInfoVivero('FUNDAZOO');
SELECT * from spGetTelefonosVivero('FUNDAZOO');
SELECT * from spGetHorarioVivero('FUNDAZOO');
*/


