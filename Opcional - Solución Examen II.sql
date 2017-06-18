--- IMPLEMENTACIÖN DE TABLAS ---
CREATE TABLE producto (
	id_producto INT NOT NULL,
	id_familia INT NOT NULL,
	CONSTRAINT pk_prod PRIMARY KEY (id_producto)
);

INSERT INTO producto VALUES (101, 1);
INSERT INTO producto VALUES (102, 2);
INSERT INTO producto VALUES (103, 3);
INSERT INTO producto VALUES (104, 1);
INSERT INTO producto VALUES (105, 2);

CREATE TABLE venta_diaria (
	id_factura INT NOT NULL,
	fecha DATE NOT NULL,
	total INTEGER NOT NULL,
	CONSTRAINT pk_venta_diaria PRIMARY KEY (id_factura)
);

INSERT INTO venta_diaria VALUES (1000,SYSDATE, 50000);
INSERT INTO venta_diaria VALUES (1001,SYSDATE - 3, 150000);
INSERT INTO venta_diaria VALUES (1002,SYSDATE - 3, 250000);
INSERT INTO venta_diaria VALUES (1003,SYSDATE, 350000);
INSERT INTO venta_diaria VALUES (1004,SYSDATE, 450000);

CREATE TABLE detalle_venta (
	id_producto INT NOT NULL,
	id_factura INT NOT NULL,
	cantidad INT NOT NULL,
	CONSTRAINT fk_prod FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
	CONSTRAINT fk_fact FOREIGN kEY (id_factura) REFERENCES venta_diaria(id_factura)
);

INSERT INTO detalle_venta VALUES (101, 1003, 52);
INSERT INTO detalle_venta VALUES (102, 1004, 62);
INSERT INTO detalle_venta VALUES (103, 1004, 25);
INSERT INTO detalle_venta VALUES (101, 1003, 75);
INSERT INTO detalle_venta VALUES (101, 1002, 21);

--- IMPLEMENTACIÓN DE TIPOS DE DATOS ---
CREATE OR REPLACE TYPE linea AS OBJECT (
	color INT,
	fecha DATE,
	cantidad INTEGER
);
/

CREATE OR REPLACE TYPE elemento IS VARRAY(3) OF FLOAT;

CREATE OR REPLACE TYPE arreglo IS TABLE OF elemento;

CREATE OR REPLACE TYPE r_elemento AS OBJECT (
	color INTEGER,
	vendidos FLOAT -- para conteo o promedio.
);
/

CREATE OR REPLACE TYPE  r_arreglo IS VARRAY(3) OF r_elemento;

CREATE OR REPLACE TYPE mayor_vendido AS OBJECT (
	color INTEGER,
	cantidad FLOAT
);
/

--- IMPLEMENTACIÓN DE CLASE ANALIZADOR ---
CREATE OR REPLACE TYPE analizador AS OBJECT (
	histo arreglo,

	CONSTRUCTOR FUNCTION analizador (f1 DATE, f2 DATE) RETURN SELF AS RESULT,
	MEMBER FUNCTION color_count RETURN r_arreglo,
	MEMBER FUNCTION color_avg RETURN r_arreglo,
	MEMBER FUNCTION color_max RETURN mayor_vendido
);
/

CREATE OR REPLACE TYPE BODY analizador AS
	CONSTRUCTOR FUNCTION analizador (f1 DATE, f2 DATE) RETURN SELF AS RESULT IS
		CURSOR c_cargador IS 	SELECT PDV.id_familia, venta_diaria.fecha, PDV.cantidad
	                            FROM (
	                                SELECT Producto.id_familia, detalle_venta.id_factura, detalle_venta.cantidad
	                                FROM PRODUCTO, DETALLE_VENTA
	                                WHERE PRODUCTO.ID_PRODUCTO = DETALLE_VENTA.ID_PRODUCTO
	                            ) PDV, VENTA_DIARIA
	                            WHERE VENTA_DIARIA.ID_FACTURA = PDV.id_factura
	                                AND VENTA_DIARIA.FECHA BETWEEN f1 AND f2;
	    c_familia INTEGER;
	    c_fecha DATE;
	    c_cantidad INTEGER;
	    periodo INTEGER;
	    offset INTEGER;
	BEGIN
		self.histo := arreglo();
	    periodo := f2 - f1;
	    self.histo.EXTEND(periodo);
	    OPEN c_cargador;
	    LOOP
	        FETCH c_cargador into c_familia, c_fecha, c_cantidad;
	            EXIT WHEN c_cargador%NOTFOUND;
	            offset := c_fecha - f1;
	            IF c_familia = 1 THEN
	                self.histo(offset).elemento(1) := self.histo(offset).elemento(1) + c_cantidad; 
	            ELSIF c_familia = 2 THEN
	                self.histo(offset).elemento(2) := self.histo(offset).elemento(2) + c_cantidad; 
	            ELSE
	                self.histo(offset).elemento(3) := self.histo(offset).elemento(3) + c_cantidad; 
	            END IF;
	    END LOOP;
	    RETURN;
	END;

	MEMBER FUNCTION color_count RETURN r_arreglo IS
		conteo_1 INTEGER := 0;
		conteo_2 INTEGER := 0;
		conteo_3 INTEGER := 0;
		res_cont r_elemento;
		resultado r_arreglo;
	BEGIN
		FOR i IN 1..histo.count LOOP
			conteo_1 := histo(i).elemento(1) + conteo_1;
			conteo_2 := histo(i).elemento(2) + conteo_2;
			conteo_3 := histo(i).elemento(3) + conteo_3;
		END LOOP;
		res_cont := elemento(1, conteo_1);
		resultado(1) := res_cont;
		res_cont := elemento(2, conteo_2);
		resultado(2) := res_cont;
		res_cont := elemento(3, conteo_3);
		resultado(3) :=
	END color_count;

	MEMBER FUNCTION color_avg RETURN r_arreglo IS
		total INTEGER := 0;
		conteo_fam INTEGER := 0;
		proporcion FLOAT := 0;
		res r_arreglo;
	BEGIN
		res := color_count();
		total := res(1).cantidad + res(2).cantidad + res(3).cantidad;
		proporcion :=  res(1).cantidad / total;
		res(1).cantidad := proporcion;
		proporcion :=  res(2).cantidad / total;
		res(2).cantidad := proporcion;
		proporcion :=  res(3).cantidad / total;
		res(3).cantidad := proporcion;

		RETURN res;
	END color_avg;

	MEMBER FUNCTION color_max RETURN mayor_vendido IS
		all_time_max INTEGER;
		color_ganador INTEGER;
		may_vend mayor_vendido;
		res r_arreglo;
	BEGIN
		res := color_count();
		all_time_max := res(1).cantidad;
		color_ganador := 1;
		IF all_time_max <= res(2).cantidad THEN
			all_time_max = res(2).cantidad;
			color_ganador := 2;
		ELSIF all_time_max <= res(3).cantidad THEN
			all_time_max = res(3).cantidad
			color_ganador := 3; 
		END IF;
		may_vend := mayor_vendido(color_ganador, all_time_max);
		return may_vend;
	END color_max;
END;
/ 



























