CREATE DATABASE db_revenda_joaofrancisco;

CREATE TABLE cliente (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE produto (
    produto_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    preco NUMERIC(10,2) NOT NULL CHECK (preco > 0),
    estoque INT DEFAULT 0 CHECK (estoque >= 0),
    codigo CHAR(8) UNIQUE
);

CREATE TABLE fornecedor (
    fornecedor_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    cidade VARCHAR(50),
    telefone VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE pedido (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES cliente(cliente_id),
    data_pedido DATE DEFAULT CURRENT_DATE,
    valor_total NUMERIC(10,2) DEFAULT 0 CHECK (valor_total >= 0),
    status VARCHAR(20) DEFAULT 'ABERTO'
);

CREATE TABLE pagamento (
    pagamento_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES pedido(pedido_id),
    metodo VARCHAR(30) NOT NULL, -- ex: Pix, Cartão Crédito, Boleto
    valor NUMERIC(10,2) NOT NULL CHECK (valor > 0),
    data_pagamento DATE DEFAULT CURRENT_DATE,
    confirmado BOOLEAN DEFAULT FALSE
);

CREATE TABLE pedido_produto (
    pedido_id INT NOT NULL REFERENCES pedido(pedido_id),
    produto_id INT NOT NULL REFERENCES produto(produto_id),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
    PRIMARY KEY (pedido_id, produto_id)
);

CREATE VIEW vw_pedido_cliente AS
SELECT p.pedido_id, c.nome AS cliente, p.data_pedido, p.valor_total, p.status
FROM pedido p
JOIN cliente c ON p.cliente_id = c.cliente_id;

CREATE VIEW vw_pedido_produto AS
SELECT pp.pedido_id, pr.nome AS produto, pp.quantidade, pp.preco_unitario,
       (pp.quantidade * pp.preco_unitario) AS subtotal
FROM pedido_produto pp
JOIN produto pr ON pp.produto_id = pr.produto_id;

INSERT INTO cliente (nome, cpf, email, telefone) VALUES
('Carlos Mendes','12345678901','carlos@email.com','119999999'),
('Fernanda Alves','22345678901','fernanda@email.com','118888888'),
('Rafael Torres','32345678901','rafael@email.com','117777777'),
('Paula Lima','42345678901','paula@email.com','116666666'),
('Gustavo Rocha','52345678901','gustavo@email.com','115555555'),
('Camila Duarte','62345678901','camila@email.com','114444444'),
('Roberto Silva','72345678901','roberto@email.com','113333333'),
('Beatriz Costa','82345678901','beatriz@email.com','112222222'),
('Marcos Vinicius','92345678901','marcos@email.com','111111111'),
('Isabela Nunes','10345678901','isabela@email.com','110000000');

INSERT INTO produto (nome, tipo, preco, estoque, codigo) VALUES
('Livro Harry Potter','Livro',59.90,20,'P0000001'),
('Livro Senhor dos Anéis','Livro',89.90,15,'P0000002'),
('Caderno Universitário','Papelaria',25.00,50,'P0000003'),
('Caneta Bic Azul','Papelaria',2.50,200,'P0000004'),
('Lapiseira Pentel','Papelaria',12.00,80,'P0000005'),
('Livro Dom Casmurro','Livro',35.00,30,'P0000006'),
('Agenda 2025','Papelaria',40.00,25,'P0000007'),
('Marcador Stabilo','Papelaria',6.00,100,'P0000008'),
('Livro O Pequeno Príncipe','Livro',29.90,40,'P0000009'),
('Kit Lápis de Cor Faber-Castell','Papelaria',55.00,18,'P0000010');

INSERT INTO fornecedor (nome, cnpj, cidade, telefone) VALUES
('Livros & Cia','11111111000100','São Paulo','119111111'),
('Editora Brasil','22222222000100','Rio de Janeiro','119222222'),
('Papelaria Central','33333333000100','Curitiba','119333333'),
('Distribuidora Letras','44444444000100','Belo Horizonte','119444444'),
('Estação do Livro','55555555000100','Salvador','119555555'),
('União Escolar','66666666000100','Fortaleza','119666666'),
('Casa dos Livros','77777777000100','Brasília','119777777'),
('Papel e Arte','88888888000100','Porto Alegre','119888888'),
('Editora Cultura','99999999000100','Recife','119999999'),
('Mundo Escolar','10101010000100','Florianópolis','118888888');

INSERT INTO pedido (cliente_id, valor_total, status) VALUES
(1,0,'ABERTO'),
(2,0,'ABERTO'),
(3,0,'ABERTO'),
(4,0,'ABERTO'),
(5,0,'ABERTO'),
(6,0,'ABERTO'),
(7,0,'ABERTO'),
(8,0,'ABERTO'),
(9,0,'ABERTO'),
(10,0,'ABERTO');

INSERT INTO pagamento (pedido_id, metodo, valor, confirmado) VALUES
(1,'Pix',59.90,TRUE),
(2,'Cartão Crédito',89.90,TRUE),
(3,'Boleto',25.00,FALSE),
(4,'Pix',70.00,TRUE),
(5,'Cartão Débito',40.00,TRUE),
(6,'Pix',29.90,FALSE),
(7,'Cartão Crédito',55.00,TRUE),
(8,'Pix',12.00,TRUE),
(9,'Boleto',6.00,FALSE),
(10,'Cartão Débito',100.00,TRUE);

INSERT INTO pedido_produto (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1,1,1,59.90),
(2,2,1,89.90),
(3,3,1,25.00),
(4,5,2,12.00),
(5,7,1,40.00),
(6,9,1,29.90),
(7,10,1,55.00),
(8,4,5,2.50),
(9,8,1,6.00),
(10,6,2,35.00);

SELECT * FROM vw_pedido_cliente;

SELECT * FROM vw_pedido_produto;
