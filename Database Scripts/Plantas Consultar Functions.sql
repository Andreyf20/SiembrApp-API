CREATE OR REPLACE FUNCTION spverplantas(filtro varchar)
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
            paisajeRecomendado varchar
)
AS
$$
    DECLARE
        filtro_wildcard varchar := (SELECT concat('%',filtro,'%'));
    BEGIN

        IF (filtro NOT LIKE '*') THEN
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
                P.paisajeRecomendado

                FROM plantas P
                LEFT JOIN familia F ON P.idFamilia = F.idFamilia
                LEFT JOIN fenologia FL ON P.idFenologia  = FL.idFenologia
                LEFT JOIN agentePolinizador AP ON P.idAgentePolinizador = AP.idAgentePolinizador
                LEFT JOIN metodoDispersion MD ON P.idMetodoDispersion = MD.idMetodoDispersion
                WHERE LOWER(P.nombreComun) LIKE lower(filtro_wildcard) or LOWER(P.nombreCientifico) LIKE lower(filtro_wildcard) or LOWER(P.origen) LIKE lower(filtro_wildcard) or LOWER(P.requerimientosDeLuz) LIKE lower(filtro_wildcard) or LOWER(P.habito) LIKE lower(filtro_wildcard) or LOWER(P.frutos) LIKE lower(filtro_wildcard) or LOWER(P.texturaFruto) LIKE lower(filtro_wildcard) or LOWER(P.flor) LIKE lower(filtro_wildcard) or LOWER(P.usosConocidos) LIKE lower(filtro_wildcard) or LOWER(P.paisajeRecomendado) LIKE lower(filtro_wildcard) or LOWER(F.nombre) LIKE lower(filtro_wildcard) or LOWER(FL.nombre) LIKE lower(filtro_wildcard) or LOWER(AP.nombre) LIKE lower(filtro_wildcard) or LOWER(MD.nombre) LIKE lower(filtro_wildcard) or P.minRangoAltitudinal :: varchar = filtro or P.maxRangoAltitudinal :: varchar = filtro or P.metros :: varchar = filtro and P.borrado = False;
        ELSE
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
                P.paisajeRecomendado

                FROM plantas P
                LEFT JOIN familia F ON P.idFamilia = F.idFamilia
                LEFT JOIN fenologia FL ON P.idFenologia  = FL.idFenologia
                LEFT JOIN agentePolinizador AP ON P.idAgentePolinizador = AP.idAgentePolinizador
                LEFT JOIN metodoDispersion MD ON P.idMetodoDispersion = MD.idMetodoDispersion
                WHERE P.borrado = False;
        END IF;
        
    END;
$$
LANGUAGE PLPGSQL;

/*
select * from spverplantas('*');
select * from spverplantas('Saragundí');
select * from spverplantas('senna reticulata');
select * from spverplantas('500');
select * from spverplantas('15m');
*/