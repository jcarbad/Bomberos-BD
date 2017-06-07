create or replace type Hidrante as object(
	id INTEGER,
	posicion GeoPoint,
	calle INTEGER,
	avenida INTEGER,
	caudalEsperado FLOAT,
	estado INTEGER,
	ultima_inspeccion Bombero,
	fecha_ultima_inspeccion DATE,
	trabajo_pendiente INT, 
	MEMBER FUNCTION distancia_a(punto GeoPoint) RETURN FLOAT
);
/

CREATE OR REPLACE TYPE BODY Hidrante AS
	-- Haversine Formula 
	MEMBER FUNCTION distancia_a(punto GeoPoint) RETURN FLOAT
	IS
		-- 1 Hidante, 2 Punto
		RADIO_TIERRA_KM constant INT := 6371; 
		gLatHidrante FLOAT := posicion.latitud;
		gLonHidrante FLOAT := posicion.longitud;
		gLatPunto FLOAT := punto.latitud;
		gLonPunto FLOAT := punto.longitud;
		deltaLat FLOAT;
		deltaLon FLOAT;
		radLatHidrante FLOAT;
		radLatPunto FLOAT;
		a FLOAT;
		c FLOAT;
		d FLOAT;
	BEGIN
		deltaLat := degreesToRadians(gLatPunto - gLatHidrante);
		deltaLon := degreesToRadians(gLonPunto - gLonHidrante);

		radLatHidrante := degreesToRadians(gLatHidrante);
		radLatPunto := degreesToRadians(gLatPunto);

		a := SIN(deltaLat / 2) * SIN(deltaLat / 2) + SIN(deltaLon / 2) * SIN(deltaLon / 2) * COS(radLatHidrante) * COS(radLatPunto);
		c := 2 * ATAN2(SQRT(a), SQRT(1-a));
		d := RADIO_TIERRA_KM * c;
		RETURN d;
	END distancia_a;
END;
/

