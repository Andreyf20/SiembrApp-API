SET timezone = 'America/Costa_Rica';

CREATE OR REPLACE FUNCTION spAgregarFenologia(

    nombreInput varchar

)
RETURNS BOOLEAN
AS $$

    DECLARE
        idFenologiaLookup BIGINT := (SELECT F.idFenologia FROM fenologia F WHERE F.nombre LIKE nombreInput);
    BEGIN

        IF idFenologiaLookup IS NOT NULL THEN

            IF (SELECT F.borrado FROM fenologia F WHERE idFenologiaLookup = F.idFenologia) = False THEN
                RETURN False;
            ELSE
                
                UPDATE fenologia SET

                    fenologia.borrado = False,
                    fenologia.ultimaActualizacion = NOW();
            END IF;
			RETURN True;

        ELSE
            
            INSERT INTO fenologia(nombre,ultimaActualizacion,borrado)
            VALUES(nombreInput,NOW(),False);

        END IF;
		RETURN True;
    END;

$$ LANGUAGE PLPGSQL;

/*
select spAgregarFenologia('Caducifolio') as success;
select spAgregarFenologia('Perennefolio') as success;
select * from fenologia;
*/

CREATE OR REPLACE FUNCTION spGetFenologias()
RETURNS TABLE(nombre varchar)
AS $$
	BEGIN
		RETURN QUERY
			SELECT F.nombre FROM fenologia F where F.borrado = false; 
	END;
$$ LANGUAGE PLPGSQL;

/*
select * from spGetFenologias();
*/