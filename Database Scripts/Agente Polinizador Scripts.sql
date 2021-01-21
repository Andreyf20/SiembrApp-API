SET timezone = 'America/Costa_Rica';

CREATE OR REPLACE FUNCTION spAgregarAgentePolinizador(

    nombreInput varchar

)
RETURNS BOOLEAN
AS $$

    DECLARE
        idAgentePolinizadorLookup BIGINT := (SELECT A.idAgentePolinizador FROM agentePolinizador A WHERE A.nombre LIKE nombreInput);
    BEGIN

        IF idAgentePolinizadorLookup IS NOT NULL THEN

            IF (SELECT A.borrado FROM agentePolinizador A WHERE idAgentePolinizadorLookup = A.idAgentePolinizador) = False THEN
                RETURN False;
            ELSE
                
                UPDATE agentePolinizador SET

                    agentePolinizador.borrado = False,
                    agentePolinizador.ultimaActualizacion = NOW();
            END IF;
			RETURN True;

        ELSE
            
            INSERT INTO agentePolinizador(nombre,ultimaActualizacion,borrado)
            VALUES(nombreInput,NOW(),False);

        END IF;
		RETURN True;
    END;

$$ LANGUAGE PLPGSQL;

/*
SELECT spAgregarAgentePolinizador('Insectos') as success;
select * from agentePolinizador;
*/

CREATE OR REPLACE FUNCTION spGetAgentesPolinizadores()
RETURNS TABLE(nombre varchar)
AS $$
	BEGIN
		RETURN QUERY
			SELECT A.nombre FROM agentepolinizador A where A.borrado = false; 
	END;
$$ LANGUAGE PLPGSQL;

/*
select * from spGetAgentesPolinizadores();
*/
