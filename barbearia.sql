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
    cpfFunc CHAR(13) NOT NULL UNIQUE,
    aluguel_cadeira DECIMAL(10,2) NOT NULL,
    telCelFunc CHAR(10) not NULL UNIQUE,
    dataCadFunc TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Clientes
CREATE TABLE Clientes (
    idCli INT AUTO_INCREMENT PRIMARY KEY,
    nomeCli VARCHAR(100) NOT NULL,
    TelCelCli VARCHAR(10) NOT NULL,
    vipCli BOOLEAN DEFAULT FALSE,
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
    FOREIGN KEY (idCategoria) REFERENCES Categorias (idCategoria)
);

-- Tabela de Agendamentos
CREATE TABLE Agendamentos (
    idAgendamento INT AUTO_INCREMENT PRIMARY KEY,
    dataAgendamento DATETIME NOT NULL UNIQUE,
    idCli INT NOT NULL,
    sinalAgendamento DECIMAL(10,2) DEFAULT 0,
    valorTotalAgendamento DECIMAL(10,2) DEFAULT NULL,
    statusAgendamento ENUM('agendado', 'concluido', 'cancelado', 'falta') DEFAULT 'agendado',
    dataCriacaoAgendamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idCli) REFERENCES Clientes(idCli)
);

-- Tabela de Detalhes dos Agendamentos
CREATE TABLE Detalhes_Agendamentos (
    idDetalhe INT AUTO_INCREMENT PRIMARY KEY,
    idAgendamento INT NOT NULL,
    idServ INT NOT NULL,
    idProd INT NOT NULL,
    qtdServicoAgendamento INT NOT NULL,
    qtdProdutoAgendamento INT NOT NULL,
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

-- Inserindo na tabela de categorias
INSERT INTO Categorias (nomeCategoria)
VALUES 
    ('Bebidas'),
    ('Produtos de cabelo');

-- Inserindo na tabela de funcionarios
use barbearia;
INSERT INTO Funcionarios (nomeFunc, loginFunc, senhaFunc, cpfFunc, aluguel_cadeira, telCelFunc)
VALUES 
    ('Paulo', 'guidio', '230905', '428.663.258-39', 100.00, '96482-8962');



-- Inserindo na tabela de clientes
INSERT INTO Clientes (nomeCli, TelCelCli, vipCli)
VALUES 
    ('Paulin', '96482-8962', FALSE);
-- Inserindo na tabela de serviços
INSERT INTO Servicos (descServ, valorServ, tempoServ)
VALUES 
    ('Corte de Cabelo Simples', 30.00, '00:45:00'),
    ('Barba', 20.00, '00:20:00');

-- Inserindo na tabela de produtos
INSERT INTO Produtos (nomeProd, descProd, precoUnitario, qtdProd, idCategoria)
VALUES 
    ('Coca-Cola', 'Refrigerante', 7.00, 10, 1),
    ('Gel', 'Bozano', 15.00, 10, 2);
    
-- Inserindo na tabela de Agendamentos
INSERT INTO Agendamentos (dataAgendamento, idCli, sinalAgendamento , valorTotalAgendamento)
VALUES 
    ('2025-04-22 16:30:00', 1, 15.00, 00.00);

-- Inserindo um único item na tabela de detalhes de agendamento
INSERT INTO Detalhes_Agendamentos (
    idAgendamento, idServ, idProd, qtdServicoAgendamento, qtdProdutoAgendamento, subtotalDetalhe
)
SELECT 
    1,  -- ID do agendamento
    Servicos.idServ,
    Produtos.idProd,
    1,  -- Quantidade do serviço (ajuste conforme necessário)
    2,  -- Quantidade do produto (ajuste conforme necessário)
    (Servicos.valorServ * 1 + Produtos.precoUnitario * 2) AS subtotal_detalhe  -- Calcula subtotal
FROM Servicos
JOIN Produtos ON Produtos.idProd = 2  -- ID do produto desejado
WHERE Servicos.idServ = 1;  -- ID do serviço desejado

-- Atualizando total da tabela de agendamentos
UPDATE Agendamentos a
JOIN (
    SELECT 
        idAgendamento,
        SUM(subtotalDetalhe) AS total
    FROM Detalhes_Agendamentos
    GROUP BY idAgendamento
) d ON a.idAgendamento = d.idAgendamento
SET 
    a.valorTotalAgendamento = d.total,
    a.sinalAgendamento = d.total * 0.5
WHERE a.idAgendamento = 1;





-- Visualizando as tabelas
SELECT * FROM Funcionarios;
SELECT * FROM Clientes;
SELECT * FROM Servicos;
SELECT * FROM Categorias;
SELECT * FROM Produtos;
SELECT * FROM Agendamentos;
SELECT * FROM Detalhes_Agendamentos;
