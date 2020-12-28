DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS TipoOrganizacion;

CREATE TABLE TipoOrganizacion(

	idTipoOrganizacion BIGSERIAL PRIMARY KEY,
	
	nombre varchar NOT NULL,
	
	ultimaActualizacion TIMESTAMPTZ NULL,
    borrado boolean NOT NULL
);

CREATE TABLE public.Users(
	
	-- Llaves
    idUsuario BIGSERIAL PRIMARY KEY,

	idTipoOrganizacion bigint NOT NULL,

	usuario_uid UUID NOT NULL,

	-- Usuario
    nombre varchar NOT NULL,

    correo varchar NOT NULL,
	
	contrasenna varchar NOT NULL,
	
	-- Otros datos
	razon varchar NOT  NULL,
	admin boolean NOT NULL,
	
	-- Trazabilidad
    ultimaActualizacion TIMESTAMPTZ NOT NULL,
    borrado boolean NOT NULL,
	
	UNIQUE(correo),
	
	FOREIGN KEY(idTipoOrganizacion)
		REFERENCES TipoOrganizacion MATCH SIMPLE
);