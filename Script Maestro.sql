------------------------- Objeto Bombero ----------------------------------
CREATE OR REPLACE TYPE bombero  AS OBJECT (
	codigo INTEGER,
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

CREATE TABLE tabla_bomberos OF bombero (codigo PRIMARY KEY)
	OBJECT IDENTIFIER IS PRIMARY KEY;

INSERT INTO TABLA_BOMBEROS(codigo, nombre) VALUES (1, 'Joan Bombero');
INSERT INTO TABLA_BOMBEROS(codigo, nombre) VALUES (2, 'Roy Bombero'); 
INSERT INTO TABLA_BOMBEROS(codigo, nombre) VALUES (3, 'Sergio Bombero');

--------------------------- Objeto GeoPoint -------------------------------
CREATE OR REPLACE TYPE GeoPoint AS OBJECT(
	latitud float,
	longitud float,
	MEMBER PROCEDURE mostrar
);
/

CREATE OR REPLACE TYPE BODY GeoPoint IS

	MEMBER PROCEDURE mostrar IS
	BEGIN
		dbms_output.put_line('Lat: ' || latitud || ', Long: ' || longitud);
	END mostrar;
END;
/

----------------------- Objeto hidrante --------------------------------------
CREATE OR REPLACE TYPE salidasArray AS VARRAY(4) OF INTEGER;

--funcion convertir Grados a Radianes
create or replace function degreesToRadians(degrees float)
return float
is 
	radian float;
begin
	radian := (degrees * 3.1415926535)/180;
	return radian;
end;
/ 

CREATE OR REPLACE TYPE Hidrante AS OBJECT (
	posicion GeoPoint,
	calle INTEGER,
	avenida INTEGER,
	caudalEsperado FLOAT,
	salidas salidasArray,
	estado INTEGER,
	ultima_inspeccion Bombero,
	fecha_ultima_inspeccion DATE,
	trabajo_pendiente INTEGER, 
	MEMBER FUNCTION distancia_KM_a(punto GeoPoint) RETURN FLOAT,
	MEMBER FUNCTION distancia_M_a(punto GeoPoint) RETURN FLOAT
);
/

CREATE OR REPLACE TYPE BODY Hidrante AS
	-- Haversine Formula 
	MEMBER FUNCTION distancia_KM_a(punto GeoPoint) RETURN FLOAT
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
		RETURN d; --
	END distancia_KM_a;

	MEMBER FUNCTION distancia_M_a(punto GeoPoint) RETURN FLOAT
	IS
		d_km FLOAT;
		d_m FLOAT;
	BEGIN
		d_km := distancia_KM_a(punto);
		d_m := d_km * 1000;
		RETURN d_m;
	END distancia_M_a;
END;
/

CREATE TABLE tabla_hidrantes OF Hidrante (
	PRIMARY KEY (posicion.latitud, posicion.longitud),
	FOREIGN KEY (ultima_inspeccion.codigo) REFERENCES tabla_bomberos(codigo))
	OBJECT IDENTIFIER IS PRIMARY KEY;


INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.016707, -84.217978), 10, 3, 50.3, salidasArray(1,2,2,3),1, 1, SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.015312, -84.216670), 8, 0, 50.3, salidasArray(1,2,2,3),1, bombero(2, 'Roy Bombero'), SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.015735, -84.214996), 4, 0, 50.3, salidasArray(1,2,2,3),1, bombero(3, 'Sergio Bombero'), SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.018566, -84.211369), 5, 3, 50.3, salidasArray(1,2,2,3),1, bombero(1, 'Joan Bombero'), SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.015143, -84.210275), 5, 4, 50.3, salidasArray(1,2,2,3),1, bombero(2, 'Roy Bombero'), SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.016897, -84.210726), 5, 0, 50.3, salidasArray(1,2,2,3),1, bombero(1, 'Joan Bombero'), SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.018080, -84.213043), 1, 3, 50.3, salidasArray(1,2,2,3),1, bombero(2, 'Roy Bombero'), SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.012185, -84.214867), 6, 8, 50.3, salidasArray(1,2,2,3),1, bombero(3, 'Sergio Bombero'), SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.013748, -84.209138), 7, 8, 50.3, salidasArray(1,2,2,3),1, bombero(1, 'Joan Bombero'), SYSDATE,0);
INSERT INTO tabla_hidrantes VALUES (GeoPoint(10.020426, -84.211005), 7, 7, 50.3, salidasArray(1,2,2,3),1, bombero(2, 'Roy Bombero'), SYSDATE,0);

------------------------ Funciones y procedimientos almacenados -------------------------

CREATE TYPE arrayHidrantes IS TABLE OF Hidrante;

CREATE OR REPLACE FUNCTION RPH(punto GeoPoint, radio FLOAT) RETURN arrayHidrantes 
IS
	CURSOR c_hidrantes IS SELECT posicion, calle, avenida, caudalEsperado, salidas 
							FROM tabla_hidrantes
							WHERE estado = 1;
	en_rango arrayHidrantes := arrayHidrantes();
	hidra Hidrante;
	distancia FLOAT := 0;
	nuevo INTEGER := 0;
BEGIN
	OPEN c_hidrantes;
	LOOP
	FETCH c_hidrantes INTO hidra.posicion, hidra.calle, hidra.avenida, hidra.caudalEsperado, hidra.salidas;
		EXIT WHEN c_hidrantes%notfound;
		distancia := hidra.distancia_KM_a(punto);
		IF (distancia < radio) THEN
			en_rango.EXTEND;
			nuevo := en_rango.LAST;
			arrayHidrantes(nuevo) := hidra;
		END IF;
	END LOOP;
	RETURN en_rango;
END;
/

------------------------ Pruebas ----------------------------------------------
DECLARE
	nuevo Hidrante := Hidrante(GeoPoint(9.9721549,-84.1283363), 10, 7, 50.3, salidasArray(1,2,2,3),1, bombero('1', 'Sergio'), SYSDATE,0);
	camion GeoPoint := GeoPoint(9.9983516,-84.139515);
	distancia FLOAT;
BEGIN
	distancia := nuevo.distancia_KM_a(camion);
	dbms_output.put_line('SE ENCUENTRA A KM: ' || distancia);
	distancia := nuevo.distancia_M_a(camion);
	dbms_output.put_line('SE ENCUENTRA A M: ' || distancia);
END;
/ 


