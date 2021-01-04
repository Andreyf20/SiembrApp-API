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
        idFamiliaLookup BIGINT := (SELECT F.idFamilia FROM familia F WHERE LOWER(F.nombre) LIKE LOWER(familiaInput));
        idFenologiaLookup BIGINT := (SELECT F.idFenologia FROM fenologia F WHERE LOWER(F.nombre) LIKE LOWER(fenologiaInput));
        idAgentePolinizadorLookup BIGINT := (SELECT A.idAgentePolinizador FROM agentePolinizador A WHERE LOWER(A.nombre) LIKE LOWER(agentePolinizadorInput));
        idMetodoDispersionLookup BIGINT := (SELECT M.idMetodoDispersion FROM metodoDispersion M WHERE LOWER(M.nombre) LIKE LOWER(metodoDispersionInput));
        idPlantaLookup BIGINT := (SELECT P.idPlanta FROM plantas P WHERE LOWER(P.nombreComun) LIKE LOWER(nombreComunInput));
    BEGIN

        IF idPlantaLookup IS NOT NULL THEN -- idPlanta existe

            IF (SELECT P.borrado FROM plantas P WHERE idPlantaLookup = P.idPlanta) = False THEN -- Planta existe y no esta borrado
                RETURN False;
            ELSE
                
                UPDATE plantas SET

                    idFamilia=idFamiliaLookup,
                    idFenologia=idFenologiaLookup,
                    idAgentePolinizador=idAgentePolinizadorLookup,
                    idMetodoDispersion=idMetodoDispersionLookup,

                    nombreCientifico=nombreCientificoInput,
                    origen=origenInput,
                    minRangoAltitudinal=minRangoAltitudinalInput,
                    maxRangoAltitudinal=maxRangoAltitudinalInput,
                    metros=metrosInput,
                    requerimientosDeLuz=requerimientosDeLuzInput,
                    habito=habitoInput,
                    frutos=frutosInput,
                    texturaFruto=texturaFrutoInput,
                    flor=florInput,
                    usosConocidos=usosConocidosInput,
                    paisajeRecomendado=paisajeRecomendadoInput,

                    borrado = False,
                    ultimaActualizacion = NOW()
					WHERE idPlanta = idPlantaLookup;
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
        'Saragundí',
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

	select spAgregarPlanta(
        'Anona, chirimoya',
        'Annona cherimola',
        'Nativa',
        1000,
        2000,
        0,
        'Requiere de luz',
        'Árbol pequeño',
        'Annonaceae',
        'Perennefolio',
        'Insectos',
        'Zoocoria',
        'Abayado',
        'Carnoso',
        'Blanco - crema',
        'Ornamental, Medicinal, frutal comestible',
        'CBIMA, PILA'

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

-- Modificar planta
CREATE OR REPLACE FUNCTION spModificarPlanta(

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
    
        idFamiliaLookup BIGINT := (SELECT F.idFamilia FROM familia F WHERE LOWER(F.nombre) LIKE LOWER(familiaInput));
        idFenologiaLookup BIGINT := (SELECT F.idFenologia FROM fenologia F WHERE LOWER(F.nombre) LIKE LOWER(fenologiaInput));
        idAgentePolinizadorLookup BIGINT := (SELECT A.idAgentePolinizador FROM agentePolinizador A WHERE LOWER(A.nombre) LIKE LOWER(agentePolinizadorInput));
        idMetodoDispersionLookup BIGINT := (SELECT M.idMetodoDispersion FROM metodoDispersion M WHERE LOWER(M.nombre) LIKE LOWER(metodoDispersionInput));
        idPlantaLookup BIGINT := (SELECT P.idPlanta FROM plantas P WHERE LOWER(P.nombreComun) LIKE LOWER(nombreComunInput));

    BEGIN

        IF idPlantaLookup IS NOT NULL THEN -- Planta existe

            IF (SELECT P.borrado FROM plantas P WHERE idPlantaLookup = P.idPlanta) = True THEN -- Planta esta en codicion de borrado
                RETURN False;

            ELSE
                
                UPDATE plantas SET

                    idFamilia=idFamiliaLookup,
                    idFenologia=idFenologiaLookup,
                    idAgentePolinizador=idAgentePolinizadorLookup,
                    idMetodoDispersion=idMetodoDispersionLookup,

                    nombreCientifico=nombreCientificoInput,
                    origen=origenInput,
                    minRangoAltitudinal=minRangoAltitudinalInput,
                    maxRangoAltitudinal=maxRangoAltitudinalInput,
                    metros=metrosInput,
                    requerimientosDeLuz=requerimientosDeLuzInput,
                    habito=habitoInput,
                    frutos=frutosInput,
                    texturaFruto=texturaFrutoInput,
                    flor=florInput,
                    usosConocidos=usosConocidosInput,
                    paisajeRecomendado=paisajeRecomendadoInput,

                    borrado = False,
                    ultimaActualizacion = NOW()
					WHERE idPlanta = idPlantaLookup;
            END IF;
			RETURN True;

        ELSE
            RETURN False; -- Planta no existe
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

/* 
{
    select spModificarPlanta(
        'Saragundí',
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
        'Amarillo',
        'Ornamental, Medicinal (Follaje)',
        'CHRTG, CBIMA, PILA, TNN'

    ) as success;
    select * from plantas;
	
	select spModificarPlanta(
        'Anona, chirimoya',
        'Annona cherimola',
        'Nativa',
        1000,
        2000,
        0,
        'Requiere de luz',
        'Árbol pequeño',
        'Annonaceae',
        'Perennefolio',
        'Insectos',
        'Zoocoria',
        'Abayado',
        'Carnoso',
        'Blanco - crema',
        'Ornamental, Medicinal, frutal comestible',
        'CBIMA, PILA'

    ) as success;
	select * from plantas;
}
*/

CREATE OR REPLACE FUNCTION spEliminarPlanta(
	nombreComunInput varchar
) RETURNS BOOLEAN
AS $$
	
	DECLARE
		
		idPlantaLookup BIGINT := (SELECT P.idPlanta FROM plantas P WHERE LOWER(P.nombreComun) LIKE LOWER(nombreComunInput));
		
	BEGIN
		
		IF idPlantaLookup IS NOT NULL THEN -- Planta existe
		
			IF (SELECT P.borrado FROM plantas P WHERE idPlantaLookup = P.idPlanta) = True THEN -- Planta esta en codicion de borrado
				
				RETURN FALSE;

			ELSE
				
				UPDATE Plantas SET
					
					ultimaActualizacion = NOW(),
					borrado = TRUE
					WHERE idPlanta = idPlantaLookup;
					
				RETURN TRUE;
			END IF;
			
		ELSE
		
			RETURN FALSE; -- Planta no existe
		
		END IF;
	END;
	
$$ LANGUAGE PLPGSQL;

/*
select spEliminarPlanta('Anona, chirimoya') as success;
select * from plantas;
*/