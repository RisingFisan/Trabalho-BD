/* Lógico_1: */

/* DROP SCHEMA transportes; */
CREATE SCHEMA IF NOT EXISTS transportes;
USE transportes;

CREATE TABLE Viagem (
    id INTEGER PRIMARY KEY,
    `data` DATE,
    matriculaAutocarro VARCHAR(8),
    NIFMotorista INTEGER,
    numeroPercurso INTEGER
);

CREATE TABLE Cliente (
    NIF INTEGER PRIMARY KEY
);

CREATE TABLE Autocarro (
    matricula VARCHAR(8) PRIMARY KEY,
    lotacao INTEGER,
    tipo VARCHAR(20),
    dataInspecao DATE
);

CREATE TABLE Passe (
    custoMensal FLOAT,
    id INTEGER PRIMARY KEY,
    dataNascimento DATE,
    nome VARCHAR(100),
    codigoPostal VARCHAR(8),
    rua VARCHAR(100),
    localidade VARCHAR(30),
    NIFCliente INTEGER
);

CREATE TABLE Paragem (
    id INTEGER PRIMARY KEY,
    nome VARCHAR(30),
    latitude DOUBLE,
    longitude DOUBLE
);

CREATE TABLE Motorista (
    nome VARCHAR(100),
    NIF INTEGER PRIMARY KEY,
    dataNascimento DATE,
    salario FLOAT,
    IBAN VARCHAR(50),
    rua VARCHAR(100),
    localidade VARCHAR(30),
    codigoPostal VARCHAR(8)
);

CREATE TABLE Percurso (
    numero INTEGER PRIMARY KEY,
    duracao TIME
);

CREATE TABLE ViagemCliente (
    idViagem INTEGER,
    NIFCliente INTEGER,
    custoBilhete FLOAT
);

CREATE TABLE ParagemPercurso (
    idParagem INTEGER,
    numeroPercurso INTEGER,
    hora TIME
);
 
ALTER TABLE Viagem ADD CONSTRAINT FK_Viagem_2
    FOREIGN KEY (matriculaAutocarro)
    REFERENCES Autocarro (matricula)
    ON DELETE CASCADE;
 
ALTER TABLE Viagem ADD CONSTRAINT FK_Viagem_3
    FOREIGN KEY (NIFMotorista)
    REFERENCES Motorista (NIF)
    ON DELETE CASCADE;
 
ALTER TABLE Viagem ADD CONSTRAINT FK_Viagem_4
    FOREIGN KEY (numeroPercurso)
    REFERENCES Percurso (numero)
    ON DELETE CASCADE;
 
ALTER TABLE Passe ADD CONSTRAINT FK_Passe_2
    FOREIGN KEY (NIFCliente)
    REFERENCES Cliente (NIF)
    ON DELETE CASCADE;
 
ALTER TABLE ViagemCliente ADD CONSTRAINT FK_ViagemCliente_1
    FOREIGN KEY (idViagem)
    REFERENCES Viagem (id)
    ON DELETE SET NULL;
 
ALTER TABLE ViagemCliente ADD CONSTRAINT FK_ViagemCliente_2
    FOREIGN KEY (NIFCliente)
    REFERENCES Cliente (NIF)
    ON DELETE SET NULL;
 
ALTER TABLE ParagemPercurso ADD CONSTRAINT FK_ParagemPercurso_1
    FOREIGN KEY (idParagem)
    REFERENCES Paragem (id)
    ON DELETE RESTRICT;
 
ALTER TABLE ParagemPercurso ADD CONSTRAINT FK_ParagemPercurso_2
    FOREIGN KEY (numeroPercurso)
    REFERENCES Percurso (numero)
    ON DELETE SET NULL;
    
CREATE INDEX NomePasse ON Passe (nome);
CREATE INDEX DataViagem ON Viagem (data);

CREATE VIEW viewPasses AS
	SELECT id, nome, dataNascimento, rua, codigoPostal,
        localidade, NIFCliente AS NIF, custoMensal FROM Passe;
        
CREATE VIEW viewViagens AS
	SELECT Viagem.id, data, matriculaAutocarro, Motorista.nome AS NomeMotorista,
		count(DISTINCT VC.NIFCliente) AS Passageiros,
		group_concat(DISTINCT Paragem.nome ORDER BY PP.hora asc) AS Paragens, duracao FROM Viagem
    JOIN ViagemCliente AS VC ON VC.idViagem = Viagem.id
    JOIN Motorista ON Viagem.NIFMotorista = Motorista.NIF
    JOIN Percurso on Viagem.numeroPercurso = Percurso.numero
    JOIN ParagemPercurso AS PP on PP.numeroPercurso = Percurso.numero
    JOIN Paragem on PP.idParagem = Paragem.id
    GROUP BY Viagem.id, Percurso.numero;