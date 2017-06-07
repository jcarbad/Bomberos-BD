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