PRAGMA foreign_keys = on; --habilito las impresindibles claves foraneas

drop table if exists usuarios;
-- creada tabla usuarios
create table usuarios(
    id_usuarios		integer primary key AUTOINCREMENT,
    usuario			varchar(16) not null, -- usuario es un string
    contrasena		varchar(16) default null, -- contraseña es un string
    estatus			varchar(1) not null check (estatus in ('f','t')) default 't'
);
create unique index if not exists usuarios_nombre on usuarios (usuario);
insert into usuarios(usuario,contrasena) values('Victor','123');

drop table if exists contactos;
-- creada tabla contactos
create table contactos(
    id_contactos	integer primary key AUTOINCREMENT,
    nombre			varchar(16) not null, -- nombre es un string
    numero			smallint not null, -- numero es un entero
    lugar			varchar(16) default null, -- tipo es un string
    fecha_registro	datetime default (datetime('now','localtime'))
);
create unique index if not exists contactos_nombre on contactos (nombre);
