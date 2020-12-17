DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS TipoOrganizacion;

CREATE TABLE TipoOrganizacion(

	idTipoOrganizacion SERIAL PRIMARY KEY,
	
	nombre varchar NOT NULL,
	
	ultimaActualizacion TIMESTAMPTZ NULL,
    borrado boolean NOT NULL
);

CREATE TABLE public.Users(
	
	-- Llaves
    idUsuario SERIAL PRIMARY KEY,
	
	idTipoOrganizacion bigint NOT NULL,
	
	-- Usuario
    nombre varchar NOT NULL,

    correo varchar NOT NULL,
	
	contrasenna varchar NOT NULL,
	
	-- Otros datos
	nombreOrganizacion varchar NOT NULL,
	razon varchar NOT  NULL,
	
	-- Trazabilidad
    ultimaActualizacion TIMESTAMPTZ NOT NULL,
    borrado boolean NOT NULL,
	
	FOREIGN KEY(idTipoOrganizacion)
		REFERENCES TipoOrganizacion MATCH SIMPLE
);