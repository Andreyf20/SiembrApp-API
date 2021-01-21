SET timezone = 'America/Costa_Rica';

CREATE OR REPLACE FUNCTION spAgregarMetodoDispersion(

    nombreInput varchar
    -- descripcion (?)
)
RETURNS BOOLEAN
AS $$

    DECLARE
        idMetodoDispersionLookup BIGINT := (SELECT M.idMetodoDispersion FROM metodoDispersion M WHERE M.nombre LIKE nombreInput);
    BEGIN

        IF idMetodoDispersionLookup IS NOT NULL THEN

            IF (SELECT M.borrado FROM metodoDispersion M WHERE idMetodoDispersionLookup = M.idMetodoDispersion) = False THEN
                RETURN False;
            ELSE
                
                UPDATE metodoDispersion SET

                    metodoDispersion.borrado = False,
                    metodoDispersion.ultimaActualizacion = NOW();
            END IF;
			RETURN True;

        ELSE
            
            INSERT INTO metodoDispersion(nombre,ultimaActualizacion,borrado)
            VALUES(nombreInput,NOW(),False);

        END IF;
		RETURN True;
    END;

$$ LANGUAGE PLPGSQL;

/*
SELECT spAgregarMetodoDispersion('Autocoria') as success;
SELECT spAgregarMetodoDispersion('Zoocoria') as success;
select * from metodoDispersion;
*/


CREATE OR REPLACE FUNCTION spGetMetodosDispersion()
RETURNS TABLE(nombre varchar)
AS $$
	BEGIN
		RETURN QUERY
			SELECT MD.nombre FROM metododispersion MD where MD.borrado = false; 
	END;
$$ LANGUAGE PLPGSQL;

/*
select * from spGetMetodosDispersion();
*/