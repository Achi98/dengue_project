
 CREATE DATABASE Dengue_Datamart;

 USE Dengue_Datamart;

CREATE TABLE DimFecha (
	Id INT PRIMARY KEY IDENTITY(1,1),
    FechaNot DATE UNIQUE,
    FechaInv DATE UNIQUE,
    FechaRegw DATE UNIQUE
);

CREATE TABLE DimGeografia (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Departam VARCHAR(255),
    Provincia VARCHAR(255),
    Distrito VARCHAR(255),
    Localidad VARCHAR(255),
    Direccion VARCHAR(255),
    PaisI VARCHAR(255),
    NombrePais VARCHAR(255),
    DeparI VARCHAR(255),
    DeparINom VARCHAR(255),
    ProvI VARCHAR(255),
    ProvINom VARCHAR(255),
    DistI VARCHAR(255),
    DistINom VARCHAR(255),
    LocalidI VARCHAR(255),
    LocaliINom VARCHAR(255),
    DirecI VARCHAR(255)
);

CREATE TABLE DimRedSalud (
    Id INT PRIMARY KEY IDENTITY(1,1),
    RedNot VARCHAR(255),
    Red VARCHAR(255),
    MrNot VARCHAR(255),
    Microred VARCHAR(255),
    EessNot VARCHAR(255),
    EessNotificante VARCHAR(255),
    Renaes VARCHAR(255),
    Categoria VARCHAR(255)
);

CREATE TABLE DimPaciente (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FecNac DATE,
    Edad INT,
    TipoEdad VARCHAR(255),
    Sexo VARCHAR(255),
    Ocupacion VARCHAR(255),
    Gestante VARCHAR(255),
    EdadGest VARCHAR(255)
);

CREATE TABLE HechosDengue (
    Id VARCHAR(255) PRIMARY KEY,
    FechaNot DATE,
    FechaInv DATE,
    TipoCaso VARCHAR(255),
    Dengue VARCHAR(255),
    Vacuna VARCHAR(255),
    Comorbi VARCHAR(255),
    InicioS DATE,
    Muestra1 VARCHAR(255),
    Fiebre VARCHAR(255),
    Prueba01 VARCHAR(255),
    Prueba02 VARCHAR(255),
    Prueba03 VARCHAR(255),
    Prueba04 VARCHAR(255),
    Prueba05 VARCHAR(255),
    Prueba06 VARCHAR(255),
    Prueba07 VARCHAR(255),
    Prueba08 VARCHAR(255),
    Prueba09 VARCHAR(255),
    Prueba10 VARCHAR(255),
    Prueba11 VARCHAR(255),
    Result01 VARCHAR(255),
    Fresult01 DATE,
    Hospit VARCHAR(255),
    Fallecim VARCHAR(255),
    Referido VARCHAR(255),
    FechaRegw DATE,
    DengueSinSignos VARCHAR(255),
    DengueConSignos VARCHAR(255),
    DengueGrave VARCHAR(255),
    DengueResult VARCHAR(255),
    Artralgias VARCHAR(255),
    Mialgias VARCHAR(255),
    Cefalea VARCHAR(255),
    DolorOcularORetroocular VARCHAR(255),
    -- Llaves foráneas
    IdGeografia INT,
    IdRedSalud INT,
    IdPaciente INT,
    CONSTRAINT FK_FactDengue_DimFechaNot FOREIGN KEY (FechaNot) REFERENCES DimFecha(FechaNot),
    CONSTRAINT FK_FactDengue_DimFechaInv FOREIGN KEY (FechaInv) REFERENCES DimFecha(FechaInv),
    CONSTRAINT FK_FactDengue_DimFechaRegw FOREIGN KEY (FechaRegw) REFERENCES DimFecha(FechaRegw),
    CONSTRAINT FK_FactDengue_DimGeografia FOREIGN KEY (IdGeografia) REFERENCES DimGeografia(Id),
    CONSTRAINT FK_FactDengue_DimRedSalud FOREIGN KEY (IdRedSalud) REFERENCES DimRedSalud(Id),
    CONSTRAINT FK_FactDengue_DimPaciente FOREIGN KEY (IdPaciente) REFERENCES DimPaciente(Id)
);


