SET timezone = 'America/Costa_Rica';

CREATE OR REPLACE FUNCTION spNuevaPlanta(
	
	nombrePlantaCientificaInput varchar,
	userIdInput BIGINT
)
RETURNS BOOLEAN
AS $$
	DECLARE 
	
		idPlantaLookup BIGINT := (SELECT P.idPlanta FROM plantas P WHERE LOWER(nombrePlantaCientificaInput) LIKE LOWER(P.nombreCientifico));
        idPxU BIGINT := (select
                        case when idPlantaLookup is not null
                        then (select 1 from plantasxusuario PXU where PXU.iduser = userIdInput and PXU.idPlanta = idPlantaLookup)
                        else -1
                        end);
	BEGIN
		
		IF idPlantaLookup IS NOT NULL THEN

            if idPxU != -1 then
                UPDATE plantasxusuario
                set ultimaActualizacion = NOW(),
                    borrado = not borrado
                where idplantaxusuario = idPxU;

            else
                INSERT INTO plantasXusuario(idPlanta,idUser,ultimaActualizacion,borrado)
                VALUES (idPlantaLookup,userIdInput,NOW(),FALSE);
            end if;
		
            RETURN TRUE;
		ELSE
			
			RETURN FALSE;
			
		END IF;
		
	END;

$$ LANGUAGE PLPGSQL;

/*
SELECT spNuevaPlanta('Senna Reticulata',1) AS success;
SELECT * FROM plantasxusuario;
*/

CREATE OR REPLACE FUNCTION spGetPlantasXUsuario(userIdInput BIGINT)
RETURNS TABLE(
            familia varchar,
            fenologia varchar,
            polinizador varchar,
            metodoDispersion varchar,

            nombreComun varchar,
            nombreCientifico varchar,
            origen varchar,
            minRangoAltitudinal real,
            maxRangoAltitudinal real,
			metros real,
            requerimientosDeLuz varchar,
            habito varchar,
            frutos varchar,
            texturaFruto varchar,
            flor varchar,
            usosConocidos varchar,
            paisajeRecomendado varchar,
            imagen TEXT
)
AS $$

	BEGIN
		
		 RETURN QUERY
                SELECT

                F.nombre,
                FL.nombre,
                AP.nombre,
                MD.nombre,

                P.nombreComun,
                P.nombreCientifico,
                P.origen,
                P.minRangoAltitudinal,
                P.maxRangoAltitudinal,
                P.metros,
                P.requerimientosDeLuz,
                P.habito,
                P.frutos,
                P.texturaFruto,
                P.flor,
                P.usosConocidos,
                P.paisajeRecomendado,
                P.imagen

                FROM plantasXusuario PXU
				INNER JOIN plantas P ON PXU.idplanta = P.idplanta
                LEFT JOIN familia F ON P.idFamilia = F.idFamilia
                LEFT JOIN fenologia FL ON P.idFenologia  = FL.idFenologia
                LEFT JOIN agentePolinizador AP ON P.idAgentePolinizador = AP.idAgentePolinizador
                LEFT JOIN metodoDispersion MD ON P.idMetodoDispersion = MD.idMetodoDispersion
                WHERE P.borrado = False and PXU.iduser = userIdInput;
	END;

$$ LANGUAGE PLPGSQL;

/*
SELECT * from spGetPlantasXUsuario(1);
*/