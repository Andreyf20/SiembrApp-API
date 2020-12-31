
SET timezone = 'America/Costa_Rica';

CREATE OR REPLACE FUNCTION spAgregarPlanta(

    nombreComunInput varchar,
    nombreCientificoInput varchar,
    origenInput varchar,
    minRangoAltitudinalInput real,
    maxRangoAltitudinalInput real,
    metrosInput real,
    requerimientosDeLuzInput varchar,
    habitoInput varchar,
    
    familiaInput varchar,
    fenologiaInput varchar,
    agentePolinizadorInput varchar,
    metodoDispersionInput varchar,

    frutosInput varchar,
    texturaFrutoInput varchar,
    florInput varchar,

    usosConocidosInput varchar,
    paisajeRecomendadoInput varchar

)
RETURNS BOOLEAN
AS $$

    DECLARE
        idFamilia BIGINT := (SELECT F.idFamilia FROM familia F WHERE LOWER(F.nombre) LIKE LOWER(familiaInput));
        idFenologia BIGINT := (SELECT F.idFenologia FROM fenologia F WHERE LOWER(F.nombre) LIKE LOWER(fenologiaInput));
        idAgentePolinizador BIGINT := (SELECT A.idAgentePolinizador FROM agentePolinizador A WHERE LOWER(A.nombre) LIKE LOWER(agentePolinizadorInput));
        idMetodoDispersion BIGINT := (SELECT M.idMetodoDispersion FROM metodoDispersion M WHERE LOWER(M.nombre) LIKE LOWER(metodoDispersionInput));
        idPlantaLookup BIGINT := (SELECT P.idPlanta FROM plantas P WHERE LOWER(P.nombreComun) LIKE LOWER(nombreComunInput));
    BEGIN

        IF idPlantaLookup IS NOT NULL THEN

            IF (SELECT P.borrado FROM plantas P WHERE idPlantaLookup = P.idPlanta) = False THEN
                RETURN False;
            ELSE
                
                UPDATE plantas SET

                    plantas.idFamilia=idFamilia,
                    plantas.idFenologia=idFenologia,
                    plantas.idAgentePolinizador=idAgentePolinizador,
                    plantas.idMetodoDispersion=idMetodoDispersion,

                    plantas.nombreCientifico=nombreCientificoInput,
                    plantas.origen=origenInput,
                    plantas.minRangoAltitudinal=minRangoAltitudinalInput,
                    plantas.maxRangoAltitudinal=maxRangoAltitudinalInput,
                    plantas.metros=metrosInput,
                    plantas.requerimientosDeLuz=requerimientosDeLuzInput,
                    plantas.habito=habitoInput,
                    plantas.frutos=frutosInput,
                    plantas.texturaFruto=texturaFrutoInput,
                    plantas.flor=florInput,
                    plantas.usosConocidos=usosConocidosInput,
                    plantas.paisajeRecomendado=paisajeRecomendadoInput,

                    plantas.borrado = False,
                    plantas.ultimaActualizacion = NOW();
            END IF;
			RETURN True;

        ELSE
            INSERT INTO plantas(
                idFamilia,
                idFenologia,
                idAgentePolinizador,
                idMetodoDispersion,

                nombreComun,
                nombreCientifico,
                origen,
                minRangoAltitudinal,
                maxRangoAltitudinal,
                metros,
                requerimientosDeLuz,
                habito,
                frutos,
                texturaFruto,
                flor,
                usosConocidos,
                paisajeRecomendado,

                -- Mantenimineto
                ultimaActualizacion,
                borrado
            )
            VALUES(
                idFamilia,
                idFenologia,
                idAgentePolinizador,
                idMetodoDispersion,

                nombreComunInput,
                nombreCientificoInput,
                origenInput,
                minRangoAltitudinalInput,
                maxRangoAltitudinalInput,
                metrosInput,
                requerimientosDeLuzInput,
                habitoInput,
                frutosInput,
                texturaFrutoInput,
                florInput,
                usosConocidosInput,
                paisajeRecomendadoInput,

                NOW(),
                False
            );
            RETURN TRUE;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

/* 
{
    select spAgregarPlanta(
        'Saragundí2',
        'Senna Reticulata',
        'Nativa',
        0,
        500,
        1800,
        'Requiere de luz',
        'ARB de 5 a 10m de altura y de >= 12.5cm de diámetro',
        'Fabaceae',
        'Caducifolio',
        'Insectos',
        'Autocoria',
        'Legumbre',
        'Seco',
        'Amarilla',
        'Ornamental, Medicinal (Follaje)',
        'CHRTG, CBIMA, PILA, TNN'

    ) as success;

    select * from plantas;
}
*/

-- Agregar filas catalogo
SELECT spAgregarFamilia('Fabaceae') as success;
SELECT spAgregarFamilia('Annonaceae') as success;
SELECT spAgregarFenologia('Caducifolio') as success;
SELECT spAgregarFenologia('Perennefolio') as success;
SELECT spAgregarAgentePolinizador('Insectos') as success;
SELECT spAgregarMetodoDispersion('Autocoria') as success;
SELECT spAgregarMetodoDispersion('Zoocoria') as success;