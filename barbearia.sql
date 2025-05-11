-- Criação do banco de dados
drop database barbearia;
CREATE DATABASE IF NOT EXISTS barbearia;
USE barbearia;

-- Tabela de Categorias
CREATE TABLE Categorias (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nomeCategoria VARCHAR(20) NOT NULL
);

-- Tabela de Funcionários
CREATE TABLE Funcionarios (
    idFunc INT AUTO_INCREMENT PRIMARY KEY,
    nomeFunc VARCHAR(100) NOT NULL,
    loginFunc VARCHAR(50) NOT NULL UNIQUE,
    senhaFunc VARCHAR(10) NOT NULL,
    cpfFunc CHAR(14) NOT NULL UNIQUE,
    aluguel_cadeira DECIMAL(10,2) NOT NULL,
    telCelFunc CHAR(10) not NULL UNIQUE,
    ativoFunc BOOLEAN DEFAULT TRUE,
    dataCadFunc TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO funcionarios (`nomeFunc`, `loginFunc`, `senhaFunc`, `cpfFunc`, aluguel_cadeira, `telCelFunc`) VALUES (
    'Paulo', 'guidio', '230905', '428.663.158-39', 150.00, '96482-8962'
)

-- Tabela de Clientes
CREATE TABLE Clientes (
    idCli INT AUTO_INCREMENT PRIMARY KEY,
    nomeCli VARCHAR(100) NOT NULL,
    TelCelCli VARCHAR(10) NOT NULL,
    vipCli BOOLEAN DEFAULT FALSE,
    ativoCli BOOLEAN DEFAULT TRUE,
    dataCadCli TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Serviços
CREATE TABLE Servicos (
    idServ INT AUTO_INCREMENT PRIMARY KEY,
    descServ VARCHAR(100) NOT NULL,
    valorServ DECIMAL(10,2) NOT NULL,
    tempoServ TIME NOT NULL, 
    ativoServ BOOLEAN DEFAULT TRUE
);

-- Tabela de Produtos
CREATE TABLE Produtos (
    idProd INT AUTO_INCREMENT PRIMARY KEY,
    nomeProd VARCHAR(100) NOT NULL,
    descProd VARCHAR(255) NOT NULL,  
    precoUnitario DECIMAL(10,2) NOT NULL,
    qtdProd INT NOT NULL,
    idCategoria INT NOT NULL,
    ativoProd BOOLEAN DEFAULT true,
    FOREIGN KEY (idCategoria) REFERENCES Categorias (idCategoria)
);

-- Tabela de Agendamentos
CREATE TABLE Agendamentos (
    idAgendamento INT AUTO_INCREMENT PRIMARY KEY,
    dataAgendamento DATETIME NOT NULL,
    idCli INT NOT NULL,
    idFunc int not NULL,
    sinalAgendamento DECIMAL(10,2) DEFAULT 0,
    valorTotalAgendamento DECIMAL(10,2) DEFAULT NULL,
    statusAgendamento ENUM('agendado', 'concluido', 'cancelado', 'falta') DEFAULT 'agendado',
    dataCriacaoAgendamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idCli) REFERENCES Clientes(idCli),
    FOREIGN KEY (idFunc) REFERENCES Funcionarios (idFunc)
);

-- Tabela de Detalhes dos Agendamentos
CREATE TABLE Detalhes_Agendamentos (
    idDetalhe INT AUTO_INCREMENT PRIMARY KEY,
    idAgendamento INT NOT NULL,
    idServ INT NOT NULL,
    idProd INT,
    qtdServicoAgendamento INT NOT NULL,
    qtdProdutoAgendamento INT,
    subtotalDetalhe DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idAgendamento) REFERENCES Agendamentos(idAgendamento),
    FOREIGN KEY (idServ) REFERENCES Servicos(idServ),
    FOREIGN KEY (idProd) REFERENCES Produtos(idProd)
);

-- Tabela de Horários Disponíveis
CREATE TABLE Horarios_Disponiveis (
    idHorario INT AUTO_INCREMENT PRIMARY KEY,
    idFunc INT NOT NULL,
    dataHorario DATETIME NOT NULL,
    disponivel BOOLEAN DEFAULT TRUE,
    bloqueado BOOLEAN DEFAULT FALSE,
    motivoBloqueio VARCHAR(255),
    FOREIGN KEY (idFunc) REFERENCES Funcionarios(idFunc),
    UNIQUE KEY (idFunc, dataHorario)
);

-- inserindo dados nas tabelas

-- Tabela de Horários Fixos
CREATE TABLE Horarios_Fixos (
    idHorario INT AUTO_INCREMENT PRIMARY KEY,
    horario TIME NOT NULL UNIQUE
);
INSERT INTO Horarios_Fixos (horario) VALUES 
('08:00:00'),
('08:50:00'),
('09:40:00'),
('10:30:00'),
('11:20:00'),
('12:10:00'),
('13:00:00'),
('13:50:00'),
('14:40:00'),
('15:30:00'),
('16:20:00'),
('17:10:00'),
('18:00:00'),
('18:50:00'),
('19:40:00'),
('20:30:00'),
('21:20:00');

-- Inserindo na tabela de categorias
INSERT INTO Categorias (nomeCategoria)
VALUES 
    ('Bebidas'),
    ('Produtos de cabelo');

-- Inserindo na tabela de serviços
INSERT INTO Servicos (descServ, valorServ, tempoServ)
VALUES 
    ('Corte de Cabelo Simples', 30.00, '00:45:00'),
    ('Barba', 20.00, '00:20:00');
