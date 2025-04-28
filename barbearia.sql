-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS barbearia;
USE barbearia;

-- Tabela de Categorias
CREATE TABLE Categorias (
    id_Categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(20) NOT NULL
);

-- Tabela de Funcionários
CREATE TABLE Funcionarios (
    id_func INT AUTO_INCREMENT PRIMARY KEY,
    nome_func VARCHAR(100) NOT NULL,
    login_func VARCHAR(50) NOT NULL UNIQUE,
    senha_func VARCHAR(10) NOT NULL,
    cpf_func CHAR(13) NOT NULL UNIQUE,
    aluguel_cadeira DECIMAL(10,2) NOT NULL,
    data_cadastro_func TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Clientes
CREATE TABLE Clientes (
    id_cli INT AUTO_INCREMENT PRIMARY KEY,
    nome_cli VARCHAR(100) NOT NULL,
    TelCel_cli VARCHAR(10) NOT NULL,
    vip_cli BOOLEAN DEFAULT FALSE,
    data_cadastro_cli TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Serviços
CREATE TABLE Servicos (
    id_serv INT AUTO_INCREMENT PRIMARY KEY,
    desc_serv VARCHAR(100) NOT NULL,
    valor_serv DECIMAL(10,2) NOT NULL,
    tempo_serv TIME NOT NULL, 
    ativo_serv BOOLEAN DEFAULT TRUE
);

-- Tabela de Produtos
CREATE TABLE Produtos (
    id_prod INT AUTO_INCREMENT PRIMARY KEY,
    nome_prod VARCHAR(100) NOT NULL,
    desc_prod VARCHAR(255) NOT NULL,  
    preco_unitario DECIMAL(10,2) NOT NULL,
    estoque_prod INT NOT NULL,
    id_Categoria INT NOT NULL,
    FOREIGN KEY (id_Categoria) REFERENCES Categorias (id_Categoria)
);

-- Tabela de Agendamentos
CREATE TABLE Agendamentos (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    data_agendamento DATETIME NOT NULL,
    id_cli INT NOT NULL,
    sinal_agendamento DECIMAL(10,2) DEFAULT 0,
    valor_total_agendamento DECIMAL(10,2) DEFAULT NULL,
    status_agendamento ENUM('agendado', 'concluido', 'cancelado', 'falta') DEFAULT 'agendado',
    data_criacao_agendamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cli) REFERENCES Clientes(id_cli)
);

-- Tabela de Detalhes dos Agendamentos
CREATE TABLE Detalhes_Agendamentos (
    id_detalhe INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT NOT NULL,
    id_serv INT NOT NULL,
    id_prod INT NOT NULL,
    qtd_serv INT NOT NULL,
    qtd_prod INT NOT NULL,
    subtotal_detalhe DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_agendamento) REFERENCES Agendamentos(id_agendamento),
    FOREIGN KEY (id_serv) REFERENCES Servicos(id_serv),
    FOREIGN KEY (id_prod) REFERENCES Produtos(id_prod)
);

-- Tabela de Horários Disponíveis
CREATE TABLE Horarios_Disponiveis (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    id_func INT NOT NULL,
    data_horario DATETIME NOT NULL,
    disponivel BOOLEAN DEFAULT TRUE,
    bloqueado BOOLEAN DEFAULT FALSE,
    motivo_bloqueio VARCHAR(255),
    FOREIGN KEY (id_func) REFERENCES Funcionarios(id_func),
    UNIQUE KEY (id_func, data_horario)
);

-- inserindo dados nas tabelas

-- Inserindo na tabela de categorias
INSERT INTO Categorias (nome_categoria)
VALUES 
    ('Bebidas'),
    ('Produtos de cabelo');

-- Inserindo na tabela de funcionarios
INSERT INTO Funcionarios (nome_func, login_func, senha_func, cpf_func, aluguel_cadeira)
VALUES 
    ('Joao', 'joaozinho', '12345', '123.123.123-99', 250.00);

-- Inserindo na tabela de clientes
INSERT INTO Clientes (nome_cli, TelCel_cli, vip_cli)
VALUES 
    ('Paulin', '96482-8962', FALSE);
-- Inserindo na tabela de serviços
INSERT INTO Servicos (desc_serv, valor_serv, tempo_serv)
VALUES 
    ('Corte de Cabelo Simples', 30.00, '00:45:00'),
    ('Barba', 20.00, '00:20:00');

-- Inserindo na tabela de produtos
INSERT INTO Produtos (nome_prod, desc_prod, preco_unitario, estoque_prod, id_Categoria)
VALUES 
    ('Coca-Cola', 'Refrigerante', 7.00, 10, 1),
    ('Gel', 'Bozano', 15.00, 10, 2);
    
-- Inserindo na tabela de Agendamentos
INSERT INTO Agendamentos (data_agendamento, id_cli, sinal_agendamento, valor_total_agendamento)
VALUES 
    ('2025-04-22 16:30:00', 1, 15.00, 00.00);

-- Inserindo na tabela de detalhes de agendamento
INSERT INTO Detalhes_Agendamentos (
    id_agendamento, id_serv, id_prod, qtd_serv, qtd_prod, subtotal_detalhe
)
SELECT 
    1,
    s.id_serv,
    p.id_prod,
    carrinho.qtd_serv,
    carrinho.qtd_prod,
    (s.valor_serv * carrinho.qtd_serv + p.preco_unitario * carrinho.qtd_prod) AS subtotal_detalhe
FROM (
    SELECT 1 AS id_serv, 1 AS id_prod, 1 AS qtd_serv, 2 AS qtd_prod
    UNION ALL
    SELECT 2 AS id_serv, 2 AS id_prod, 1 AS qtd_serv, 1 AS qtd_prod
) AS carrinho
JOIN Servicos s ON s.id_serv = carrinho.id_serv
JOIN Produtos p ON p.id_prod = carrinho.id_prod;

-- Atualizando total da tabela de agendamentos
UPDATE Agendamentos a
JOIN (
    SELECT 
        id_agendamento,
        SUM(subtotal_detalhe) AS total
    FROM Detalhes_Agendamentos
    GROUP BY id_agendamento
) d ON a.id_agendamento = d.id_agendamento
SET 
    a.valor_total_agendamento = d.total,
    a.sinal_agendamento = d.total * 0.5
WHERE a.id_agendamento = 1;





-- Visualizando as tabelas
SELECT * FROM Funcionarios;
SELECT * FROM Clientes;
SELECT * FROM Servicos;
SELECT * FROM Categorias;
SELECT * FROM Produtos;
SELECT * FROM Agendamentos;
SELECT * FROM Detalhes_Agendamentos;
