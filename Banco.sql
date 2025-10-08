USE Banco;
GO

DROP TABLE IF EXISTS transacao;
DROP TABLE IF EXISTS cliente_conta;
DROP TABLE IF EXISTS conta_corrente;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS agencia;
GO


CREATE TABLE agencia ( 
    cod_agencia INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE cliente (
    cod_cliente INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,

);

CREATE TABLE conta_corrente (
    cod_conta INT PRIMARY KEY IDENTITY(1,1),
    cod_cliente INT NOT NULL,
    cod_agencia INT NOT NULL,
    saldo DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    data_abertura DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (cod_cliente) REFERENCES cliente(cod_cliente),
    FOREIGN KEY (cod_agencia) REFERENCES agencia(cod_agencia)
    );

CREATE TABLE cliente_conta(
    cod_cliente INT NOT NULL,
    cod_conta INT NOT NULL,
    PRIMARY KEY (cod_cliente, cod_conta),
    FOREIGN KEY (cod_cliente) REFERENCES cliente(cod_cliente),
    FOREIGN KEY (cod_conta) REFERENCES conta_corrente(cod_conta)
)

CREATE TABLE transacao (
    cod_transacao INT PRIMARY KEY IDENTITY(1,1),
    cod_conta INT NOT NULL,
    tipo CHAR(1) NOT NULL CHECK (tipo IN ('D', 'C')), -- D: Débito, C: Crédito
    valor DECIMAL(15,2) NOT NULL,
    data_transacao DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (cod_conta) REFERENCES conta_corrente(cod_conta)
);

USE Banco;
GO


INSERT INTO agencia (nome)
VALUES 
('Agência Centro'),
('Agência Paulista'),
('Agência Sorocaba');
GO


INSERT INTO cliente (nome, cpf, data_nascimento)
VALUES
('João Silva', '12345678901', '1990-05-12'),
('Maria Oliveira', '23456789012', '1988-03-20'),
('Carlos Souza', '34567890123', '1995-11-05');
GO


INSERT INTO conta_corrente (cod_cliente, cod_agencia, saldo, data_abertura)
VALUES
(1, 1, 1500.00, GETDATE()),   
(2, 2, 2500.00, GETDATE()),   
(3, 3, 350.00, GETDATE());    
GO


INSERT INTO cliente_conta (cod_cliente, cod_conta)
VALUES
(1, 1),  
(2, 2), 
(3, 3);  
GO


INSERT INTO cliente_conta (cod_cliente, cod_conta)
VALUES
(1, 2);  


INSERT INTO transacao (cod_conta, tipo, valor, data_transacao)
VALUES
(1, 'C', 500.00, GETDATE()),   
(1, 'D', 200.00, GETDATE()),   
(2, 'C', 1000.00, GETDATE()), 
(3, 'D', 50.00, GETDATE());    
GO


SELECT * FROM agencia;
GO

SELECT * FROM cliente;
GO

SELECT * FROM conta_corrente;
GO

SELECT * FROM transacao;
GO

SELECT 
    t.cod_transacao,
    t.tipo,
    t.valor,
    t.data_transacao
FROM transacao t
WHERE t.cod_conta = 1
ORDER BY t.data_transacao DESC;
GO

SELECT 
    c.nome AS Cliente,
    cc.cod_conta AS Conta,
    a.nome AS Agencia,
    cc.saldo
FROM conta_corrente cc
JOIN cliente c ON cc.cod_cliente = c.cod_cliente
JOIN agencia a ON cc.cod_agencia = a.cod_agencia;
GO

SELECT 
    c.nome AS Cliente,
    cc.cod_conta AS Conta
FROM cliente_conta cc
JOIN cliente c ON c.cod_cliente = cc.cod_cliente
ORDER BY cc.cod_conta;
GO
