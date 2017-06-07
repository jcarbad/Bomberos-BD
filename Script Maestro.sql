-- Constantes
DECLARE 
   PI constant number := 3.141592654;
   
BEGIN  
   -- output 
   dbms_output.put_line('Pi: ' || PI); 
END; 
/

-- Objeto Bombero
CREATE OR REPLACE TYPE bombero  AS OBJECT (
	codigo VARCHAR(10),
	nombre VARCHAR(35),
	MEMBER PROCEDURE mostrar
);
/

CREATE OR REPLACE TYPE BODY bombero AS
	MEMBER PROCEDURE mostrar IS
	BEGIN
		dbms_output.put_line('Codigo:' || codigo);
		dbms_output.put_line('Nombre:' || nombre);
	END mostrar;
END;
/

--objeto geopoint
create or replace type GeoPoint as object
(
	latitud float,
	longitud float
);
/

--funciones convertir Grados a Radianes
create or replace function degreesToRadians(degrees float)
return float
is 
	radian float;
begin
	radian := (degrees * 3.1415926535)/180;
	return radian;
end;
/

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

CREATE OR REPLACE PROCEDURE pruebaHidrantes 
AS
	nuevo Hidrante := Hidrante(1, GeoPoint(9.9721549,-84.1283363), 10, 7, 50.3, 1, bombero('1', 'Sergio'), SYSDATE,0);
	camion GeoPoint := GeoPoint(9.9983516,-84.139515);
	distancia FLOAT;
BEGIN
	distancia := nuevo.distancia_a(camion);
	dbms_output.put_line('SE ENCUENTRA A KM: ' || distancia);
END;
/ 


