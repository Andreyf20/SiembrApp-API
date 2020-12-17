-- Archivo para stored procedures y funciones de la base de datos de usuarios

/*
Password encription 
Ref: https://dbtut.com/index.php/2018/10/01/column-level-encryption-with-pgcrypto-on-postgresql/
    #Encrypt: "PGP_SYM_ENCRYPT('The value to be entered in the column:','AES_KEY');
    #Decrypt: "PGP_SYM_DECRYPT(column_name::bytea,'AES_KEY');
*/

DROP EXTENSION IF EXISTS pgcrypto;
CREATE EXTENSION pgcrypto;

SET timezone = 'America/Costa_Rica';

CREATE OR REPLACE FUNCTION spCrearUsuario(

    nombreInput varchar,
    correoInput varchar,
    contrasennaInput varchar,
	tipoOrganizacionInput varchar,
	nombreOrganizacionInput varchar,
	razonInput varchar
)
RETURNS BOOLEAN
AS $$

    DECLARE
        idUsuarioBuscado BIGINT := (SELECT U.idUsuario FROM Users U WHERE U.correo LIKE correoInput);
		idTipoOrganizacion BIGINT := (SELECT T.idTipoOrganizacion FROM TipoOrganizacion T WHERE T.nombre LIKE tipoOrganizacionInput);
    BEGIN

        IF idUsuarioBuscado IS NOT NULL THEN
            
            IF ((SELECT U.borrado FROM Users U WHERE U.idUsuario = idUsuarioBuscado) = False) THEN
				RETURN FALSE;
            ELSE
                	
				UPDATE Users SET
					borrado = False,
					ultimaActualizacion = NOW()
					WHERE Users.idUsuario = idUsuarioBuscado;
			END IF;
            RETURN TRUE;
        ELSE

                INSERT INTO Users(
                    nombre,
                    correo,
                    contrasenna,
                    idTipoOrganizacion,
					nombreOrganizacion,
					razon,
                    ultimaActualizacion,
                    borrado
                )
                VALUES(
                    nombreInput,
                    correoInput,
                    Crypt(contrasennaInput,'md5'),
                    idTipoOrganizacion,
					nombreOrganizacionInput,
					razonInput,
                    NOW(),
                    FALSE
                );

			RETURN TRUE;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

/*
SELECT spCrearUsuario('Administrador','admin@siembrapp.com','admin','Uso personal','Personal') as success;
select * from Users;
*/

-- Login
CREATE OR REPLACE FUNCTION spLogin(correoInput VARCHAR,passwordInput VARCHAR)
RETURNS BOOLEAN AS $$

	DECLARE
		correoEncontrado VARCHAR := (SELECT U.correo FROM users U WHERE U.correo = correoInput and U.borrado = False);
        encryptedPass VARCHAR := (SELECT U.contrasenna FROM users U where U.correo = correoEncontrado);
        pass VARCHAR := Crypt(passwordInput,'md5');
	BEGIN
		
		IF correoEncontrado IS NOT NULL THEN
			IF (pass LIKE encryptedPass) THEN
				RETURN TRUE;
			ELSE
				RETURN FALSE;
			END IF;
		ELSE
			BEGIN
				RETURN FALSE;
			END;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

/*
select spLogin('admin@siembrapp.com','admin') as success;
*/


CREATE OR REPLACE FUNCTION spCrearTipoOrganizacion(nombreInput varchar)
RETURNS BOOLEAN AS $$
	
	DECLARE
		
		idTipoOrganizacionLookup BIGINT := (SELECT T.idTipoOrganizacion FROM TipoOrganizacion T WHERE T.nombre LIKE nombreInput);
	
	BEGIN
		
		IF idTipoOrganizacionLookup IS NOT NULL THEN
			
			IF (SELECT T.borrado FROM TipoOrganizacion T WHERE idTipoOrganizacionLookup = T.idTipoOrganizacion) = False THEN
                RETURN False;
            ELSE
                
                UPDATE TipoOrganizacion SET

                    TipoOrganizacion.borrado = False,
                    TipoOrganizacion.ultimaActualizacion = NOW();
					
            END IF;
			RETURN True;
			
		ELSE
			
			INSERT INTO TipoOrganizacion(nombre,ultimaActualizacion,borrado)
			VALUES (nombreInput, NOW(), False);
			
		END IF;
		RETURN TRUE;
		
	END;
$$ LANGUAGE PLPGSQL;

select spCrearTipoOrganizacion('Asada') as success;
select spCrearTipoOrganizacion('Estado') as success;
select spCrearTipoOrganizacion('Gobierno local') as success;
select spCrearTipoOrganizacion('ONG') as success;
select spCrearTipoOrganizacion('Otro') as success;
select * from TipoOrganizacion;