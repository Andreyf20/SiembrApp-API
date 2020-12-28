SET timezone = 'America/Costa_Rica';

-- Crear tabla de viveros
CREATE TABLE Viveros(

	idVivero SERIAL NOT NULL PRIMARY KEY,
	nombre varchar NOT NULL UNIQUE,
	direccion varchar NOT NULL,
	
	telefonos varchar NOT NULL,
	horarios varchar NOT NULL,
	
	ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL
);

-- Funciones

-- Agregar
CREATE OR REPLACE FUNCTION spAgregarVivero(
	nombreInput varchar,
	direccionInput varchar,
	telefonosInput varchar,
	horariosInput varchar
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
					telefonos = telefonosInput,
					horarios = horariosInput,
					borrado = FALSE,
					ultimaActualizacion = NOW() WHERE idViveroLookup = Viveros.idVivero;
					
					RETURN TRUE;	
			ELSE 
				
				RETURN FALSE;
				
			END IF;
			
		ELSE
		
			INSERT INTO Viveros (nombre, direccion, telefonos, horarios, ultimaActualizacion, borrado)
			VALUES (nombreInput,direccionInput, telefonosInput, horariosInput, NOW(), FALSE);
				
			RETURN TRUE;
		
		END IF;
		
	END;

$$ LANGUAGE PLPGSQL;

/*
	select spAgregarVivero('FUNDAZOO',
	'Calle Ross De la Cruz Roja de Santa Ana 300 metros oeste y 200 metros norte, San Jose, Santa Ana',
	'2282 8434',
	'8:00 - 15:30 (Lunes - Viernes)
	9:00 - 16:30 (Sábados y domingos)')
	as success;
	select * from Viveros;
*/

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

/*
select * from spListViveros();
*/

-- Consultar informacion de vivero

CREATE OR REPLACE FUNCTION spGetInfoVivero(
	nombreViveroInput varchar
)
RETURNS TABLE(nombre varchar, direccion varchar, telefonos varchar, horarios varchar)
AS
$$
	DECLARE 
		
		idViveroLookup BIGINT := (SELECT V.idVivero FROM Viveros V WHERE LOWER(V.nombre) LIKE LOWER(nombreViveroInput) and V.borrado = FALSE);
		
	BEGIN
	
		RETURN QUERY
		SELECT V.nombre, V.direccion,V.telefonos,V.horarios FROM Viveros V WHERE V.borrado = FALSE;
		
	END;
$$ LANGUAGE PLPGSQL;

/*
select * from spGetInfoVivero('FUNDAZOO');
*/

-- Modificar datos de vivero

CREATE OR REPLACE FUNCTION spModificarVivero(
	nombreViveroInput varchar,
	direccionNuevaInput varchar,
	telefonosInput varchar,
	horariosInput varchar
) RETURNS BOOLEAN
AS
$$

	DECLARE 
	
		idViveroLookup BIGINT := (SELECT V.idVivero FROM Viveros V WHERE LOWER(V.nombre) LIKE LOWER(nombreViveroInput) and V.borrado = FALSE);

	BEGIN
	
		IF idViveroLookup IS NOT NULL THEN
			
			UPDATE Viveros SET

				direccion = direccionInput,
				telefonos = telefonosInput,
				horarios = horariosInput,
				borrado = FALSE,
				ultimaActualizacion = NOW() WHERE idViveroLookup = Viveros.idVivero;

			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
		
	END;

$$ LANGUAGE PLPGSQL;