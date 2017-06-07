-- Constantes
DECLARE 
   PI constant number := 3.141592654;
   RADIO_TIERRA_KM INT := 6371; 
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
	longitud float,
);
/

--funciones almacenadas
create or replace function degreestoradians(degrees float)
return float
is 
	radian float;
begin
	radian := (degrees * 3.1415926535)/180;
	return radian;
end;
/