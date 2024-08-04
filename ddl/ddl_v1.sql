/*Creacion de la BD*/
CREATE DATABASE DatamartDengue;

USE DatamartDengue;

/*Creacion de las tablas dimensionales*/

CREATE TABLE dim_fecha (
    fecha_id DATE PRIMARY KEY,
    anio INT,
    mes INT,
    dia INT,
    semana INT
);

CREATE TABLE dim_red (
    red_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_red NVARCHAR(255),
    descripcion_red NVARCHAR(255)
);

CREATE TABLE dim_microred (
    microred_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_microred NVARCHAR(255),
    descripcion_microred NVARCHAR(255)
);

CREATE TABLE dim_eess (
    eess_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_eess NVARCHAR(255),
    tipo_eess NVARCHAR(255),
    direccion_eess NVARCHAR(255)
);

/*Creacion de la tabla de hechos*/

CREATE TABLE hechos_dengue (
    id INT PRIMARY KEY,
    fecha_notificacion DATE,
    fecha_investigacion DATE,
    red_notificacion_id INT,
    microred_id INT,
    eess_notificacion_id INT,
    cantidad_casos INT,
    fecha_notificacion_id DATE,
    fecha_investigacion_id DATE,
    FOREIGN KEY (red_notificacion_id) REFERENCES dim_red(red_id),
    FOREIGN KEY (microred_id) REFERENCES dim_microred(microred_id),
    FOREIGN KEY (eess_notificacion_id) REFERENCES dim_eess(eess_id),
    FOREIGN KEY (fecha_notificacion_id) REFERENCES dim_fecha(fecha_id),
    FOREIGN KEY (fecha_investigacion_id) REFERENCES dim_fecha(fecha_id)
);

