create or replace type formulario as object(
	codigo int,
	hidrante GeoPoint
)not final;
/

create type mantenimiento under formulario(
	tipo int
);
/

create type realizado under formulario(
	anotacion varchar(100)
);
/

