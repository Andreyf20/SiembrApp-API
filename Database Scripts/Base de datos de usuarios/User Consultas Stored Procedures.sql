SET timezone = 'America/Costa_Rica';

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
	razon varchar)
AS $$
	DECLARE
		
		nombretipoorganizacion varchar := (SELECT T.nombre FROM users U INNER JOIN tipoOrganizacion T ON U.idTipoOrganizacion = T.idTipoOrganizacion where U.correo = correoInput);
		uidString varchar :=  (SELECT spGetUserUUIDwithEmail(correoInput));
		
	BEGIN
		
		RETURN QUERY
		
			SELECT uidString as uid, U.nombre as nombre , U.correo as correo, nombretipoorganizacion, U.razon as razon
			FROM public.users U;
			
    END;

$$ LANGUAGE PLPGSQL;

/*
select * from spGetUserInfo('admin@siembrapp.com');
*/
