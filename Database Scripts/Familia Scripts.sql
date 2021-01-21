SET timezone = 'America/Costa_Rica';

-- Agregar nuevo tipo de familia
CREATE OR REPLACE FUNCTION spAgregarFamilia(

    nombreInput varchar

)
RETURNS BOOLEAN
AS $$

    DECLARE
        idFamiliaLookup BIGINT := (SELECT F.idFamilia FROM familia F WHERE F.nombre LIKE nombreInput);
    BEGIN

        IF idFamiliaLookup IS NOT NULL THEN

            IF (SELECT F.borrado FROM familia F WHERE idFamiliaLookup = F.idFamilia) = False THEN
                RETURN False;
            ELSE
                
                UPDATE familia SET

                    familia.borrado = False,
                    familia.ultimaActualizacion = NOW();
                    
            END IF;
			RETURN True;

        ELSE
            
            INSERT INTO familia(nombre,ultimaActualizacion,borrado)
            VALUES(nombreInput,NOW(),False);

        END IF;
		RETURN True;
    END;

$$ LANGUAGE PLPGSQL;

/*
select spAgregarFamilia('Fabaceae') as success;
select spAgregarFamilia('Annonaceae') as success;
SELECT * FROM familia;
*/


CREATE OR REPLACE FUNCTION spGetFamilias()
RETURNS TABLE(nombre varchar)
AS $$
	BEGIN
		RETURN QUERY
			SELECT F.nombre FROM familia F where F.borrado = false; 
	END;
$$ LANGUAGE PLPGSQL;

/*
select * from spGetFamilias();
*/