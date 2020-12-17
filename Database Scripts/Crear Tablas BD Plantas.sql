
DROP TABLE IF EXISTS plantas;
DROP TABLE IF EXISTS familia;
DROP TABLE IF EXISTS fenologia;
DROP TABLE IF EXISTS agentePolinizador;
DROP TABLE IF EXISTS metodoDispersion;


-- <Tablas catalogo>

-- Tabla familia de plantas
CREATE TABLE public.familia(
    idFamilia SERIAL PRIMARY KEY,
    nombre varchar(512) NOT NULL,

    ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL
);

-- Tabla tipos de fenologia
CREATE TABLE public.fenologia(
    idFenologia SERIAL PRIMARY KEY,
    nombre varchar(512) NOT NULL,

    ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL
);

-- Tabla tipos de agente polinizador
CREATE TABLE public.agentePolinizador(
    idAgentePolinizador serial primary key,
    nombre varchar(512) NOT NULL,

    ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL
);

-- Tabla tipo metodo de dispersion
CREATE TABLE public.metodoDispersion(
    idMetodoDispersion SERIAL PRIMARY KEY,
    nombre varchar(512) NOT NULL,
    -- descripcion (?)
    ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL
);

-- <Fin tablas catalogo>

CREATE TABLE public.plantas(
    
    -- PK
    idPlanta SERIAL PRIMARY KEY,

    -- FKs
    idFamilia bigint NOT NULL,
    idFenologia bigint NOT NULL,
    idAgentePolinizador bigint NOT NULL,
    idMetodoDispersion bigint NOT NULL,

    -- Info planta
    nombreComun varchar(512) NOT NULL,
    nombreCientifico varchar(512) NOT NULL,
    origen varchar(512) NOT NULL,
    minRangoAltitudinal real NOT NULL,
    maxRangoAltitudinal real NOT NULL,
    metros real NOT NULL,
    requerimientosDeLuz varchar(512) NOT NULL,
    habito varchar(1024) NOT NULL,
    
    frutos varchar(512) NOT NULL,
    texturaFruto varchar(512) NOT NULL,
    flor varchar(512) NOT NULL,

    usosConocidos varchar(1024) NOT NULL,
    paisajeRecomendado varchar(1024) NOT NULL,

    -- Mantenimineto
    ultimaActualizacion TIMESTAMP NOT NULL,
    borrado boolean NOT NULL,

    -- user name de la ultima actualizacion (?)
    -- foto (?)

    FOREIGN KEY(idFamilia)
        REFERENCES public.familia MATCH SIMPLE,

    FOREIGN KEY(idFenologia)
        REFERENCES public.fenologia MATCH SIMPLE,

    FOREIGN KEY(idAgentePolinizador)
        REFERENCES public.agentePolinizador MATCH SIMPLE,

    FOREIGN KEY(idMetodoDispersion)
        REFERENCES public.metodoDispersion MATCH SIMPLE
);


