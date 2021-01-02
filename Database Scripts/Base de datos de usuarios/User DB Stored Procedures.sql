-- Archivo para stored procedures y funciones de la base de datos de usuarios

/*
Password encription 
Ref: https://dbtut.com/index.php/2018/10/01/column-level-encryption-with-pgcrypto-on-postgresql/
    #Encrypt: "PGP_SYM_ENCRYPT('The value to be entered in the column:','AES_KEY');
    #Decrypt: "PGP_SYM_DECRYPT(column_name::bytea,'AES_KEY');
*/

DROP EXTENSION IF EXISTS pgcrypto;
CREATE EXTENSION pgcrypto;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SET timezone = 'America/Costa_Rica';

CREATE OR REPLACE FUNCTION spCrearUsuario(

    nombreInput varchar,
    correoInput varchar,
    contrasennaInput varchar,
	tipoOrganizacionInput varchar,
	razonInput varchar,
	adminInput boolean
)
RETURNS BOOLEAN
AS $$

    DECLARE
        idUsuarioBuscado BIGINT := (SELECT U.idUsuario FROM Users U WHERE U.correo LIKE correoInput);
		idTipoOrganizacion BIGINT := (SELECT T.idTipoOrganizacion FROM TipoOrganizacion T WHERE T.nombre LIKE tipoOrganizacionInput);
		usuario_uid uuid := (SELECT uuid_generate_v4());
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
					usuario_uid,
					razon,
					admin,
                    ultimaActualizacion,
                    borrado
                )
                VALUES(
                    nombreInput,
                    correoInput,
                    Crypt(contrasennaInput,'md5'),
                    idTipoOrganizacion,
					usuario_uid,
					razonInput,
					adminInput,
                    NOW(),
                    FALSE
                );

			RETURN TRUE;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

/*
SELECT spCrearUsuario('Administrador','admin@siembrapp.com','admin','Otro','Otro',TRUE) as success;
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

/*
select spCrearTipoOrganizacion('Asada') as success;
select spCrearTipoOrganizacion('Estado') as success;
select spCrearTipoOrganizacion('Gobierno local') as success;
select spCrearTipoOrganizacion('ONG') as success;
select spCrearTipoOrganizacion('Otro') as success;
select * from TipoOrganizacion;
*/

drop function if exists spUpdateUsuario;

CREATE OR REPLACE FUNCTION spUpdateUsuario(
    nombreInput varchar,
    correoInput varchar,
	tipoOrganizacionInput varchar,
	usuario_uidInput varchar
)
RETURNS BOOLEAN
AS $$

    DECLARE
        idUsuarioBuscado BIGINT := (SELECT U.idUsuario FROM Users U WHERE U.usuario_uid::varchar LIKE usuario_uidInput);
		_idTipoOrganizacion BIGINT := (SELECT T.idTipoOrganizacion FROM TipoOrganizacion T WHERE T.nombre LIKE tipoOrganizacionInput);
		correoRepetido BOOLEAN := (select
									case when exists (SELECT 1 FROM Users U WHERE U.correo LIKE correoInput LIMIT 1)
										then TRUE
										else FALSE
									end);
    BEGIN

        IF idUsuarioBuscado IS NOT NULL THEN
            
            IF ((SELECT U.borrado FROM Users U WHERE U.idUsuario = idUsuarioBuscado) = True) 
			OR correoRepetido THEN
				RETURN FALSE;
            ELSE	
				UPDATE Users U SET
					nombre = nombreInput,
					correo = correoInput,
					idtipoorganizacion = _idTipoOrganizacion,
					ultimaActualizacion = NOW()
					WHERE U.idUsuario = idUsuarioBuscado;
			END IF;
            RETURN TRUE;
        ELSE
			RETURN FALSE;
        END IF;
    END;
$$ LANGUAGE PLPGSQL;

-- select spUpdateUsuario('XD', 'xd3@gmail.com', 'ONG', '860f39d0-6ee6-47a9-a34f-0e449b8bd477') as success;

-- Retorna el UUID usando el correo del usuario
CREATE OR REPLACE FUNCTION spGetUserUUIDwithEmail(

    emailInput varchar

)
RETURNS VARCHAR
AS $$		
	BEGIN
		
		RETURN (SELECT U.usuario_uid FROM Users U WHERE U.correo LIKE emailInput);
		
    END;

$$ LANGUAGE PLPGSQL;

/*
SELECT spGetUserUUIDwithEmail('admin@siembrapp.com') as id;
*/

-- Retorna el ID del usuario usando el UUID
CREATE OR REPLACE FUNCTION spGetUserIdwithUUID(

    userUUIDInput varchar

)
RETURNS BIGINT
AS $$
	DECLARE
		
		inputAsUUID UUID := CAST(userUUIDInput AS UUID);
		
	BEGIN
		
		RETURN (SELECT U.idusuario FROM Users U WHERE usuario_uid = inputAsUUID);
		
    END;

$$ LANGUAGE PLPGSQL;

/*
SELECT spGetUserIdwithUUID('b66a1bc7-0efb-4417-a20e-9190ab768b32') as "User ID";
*/

-- Retorna la informacion del usuario por correo
CREATE OR REPLACE FUNCTION spGetUserInfo(

    correoInput varchar

)
RETURNS TABLE(
	uid varchar,
    nombre varchar,
	correo varchar,
	nombretipoOrganizacion varchar,
	razon varchar,
	admin boolean)
AS $$
	DECLARE
		
		nombretipoorganizacion varchar := (SELECT T.nombre FROM users U INNER JOIN tipoOrganizacion T ON U.idTipoOrganizacion = T.idTipoOrganizacion where U.correo = correoInput);
		uidString varchar :=  (SELECT spGetUserUUIDwithEmail(correoInput));
		
	BEGIN
		
		RETURN QUERY
		
			SELECT uidString as uid, U.nombre as nombre , U.correo as correo, nombretipoorganizacion, U.razon, U.admin as razon
			FROM public.users U WHERE uidString like U.usuario_uid::varchar;
		
    END;

$$ LANGUAGE PLPGSQL;

/*
select * from spGetUserInfo('admin@siembrapp.com');
*/

