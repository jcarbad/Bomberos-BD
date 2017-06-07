create type Hidrante as object(
	id INTEGER,
	posicion GeoPoint.
	calle INTEGER,
	avenida INTEGER,
	caudalEsperado FLOAT,
	estado INTEGER,
	ultima_inspeccion Bombero,
	fecha_ultima_inspeccion DATE,
	trabajo_pendiente BOOLEAN, 
	MEMBER FUNCTION distancia_a(GeoPoint) RETURN FLOAT
);
/

CREATE TYPE BODY Hidrante AS 
	MEMBER FUNCTION distancia_a(GeoPoint) RETURN FLOAT IS
	BEGIN
		RETURN 0;
	END distancia;
END;
/
