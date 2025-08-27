% significa qualquer sequência de caracteres.
O comando retorna todos os clientes cujo nome inicia com "C".

SELECT * FROM cliente
WHERE nome LIKE 'C%';

EXPLAIN SELECT * FROM cliente
WHERE nome LIKE 'C%';

Criamos um índice na coluna nome da tabela cliente para acelerar buscas por esse campo.

CREATE INDEX idx_cliente_nome ON cliente(nome);

EXPLAIN SELECT * FROM cliente
WHERE nome LIKE 'C%';

Pode gerar erro se algum valor não for numérico (exemplo: telefone com caracteres especiais).
Caso todos os valores sejam numéricos simples, a conversão funciona.

ALTER TABLE cliente
ALTER COLUMN telefone TYPE INT;

Essa conversão funciona sem erro porque todo número pode virar texto.
Mas a coluna deixa de suportar operações numéricas diretamente (ex: soma, média).

ALTER TABLE produto
ALTER COLUMN estoque TYPE VARCHAR;

Com joaofrancisco, tudo funciona.
Com colega, só é possível usar SELECT em cliente.
Qualquer tentativa de INSERT, UPDATE ou DELETE gera erro de permissão.

CREATE USER joaofrancisco WITH PASSWORD '123456';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO joaofrancisco;

CREATE USER colega WITH PASSWORD '123456';
GRANT SELECT ON cliente TO colega;

Com os campos NULL, os INNER JOIN deixam de mostrar esses registros.

Já os LEFT JOIN continuam mostrando os registros da tabela principal, mas os campos ficam NULL.
Nos RIGHT JOIN ocorre o mesmo, mas priorizando a segunda tabela.

-- INNER JOIN
SELECT c.nome, p.pedido_id, p.valor_total
FROM cliente c
INNER JOIN pedido p ON c.cliente_id = p.cliente_id;

-- LEFT JOIN
SELECT c.nome, p.pedido_id, p.valor_total
FROM cliente c
LEFT JOIN pedido p ON c.cliente_id = p.cliente_id;

-- RIGHT JOIN
SELECT c.nome, p.pedido_id, p.valor_total
FROM cliente c
RIGHT JOIN pedido p ON c.cliente_id = p.cliente_id;

-- INNER JOIN
SELECT p.pedido_id, pr.nome, pp.quantidade
FROM pedido p
INNER JOIN pedido_produto pp ON p.pedido_id = pp.pedido_id
INNER JOIN produto pr ON pp.produto_id = pr.produto_id;

-- LEFT JOIN
SELECT p.pedido_id, pr.nome, pp.quantidade
FROM pedido p
LEFT JOIN pedido_produto pp ON p.pedido_id = pp.pedido_id
LEFT JOIN produto pr ON pp.produto_id = pr.produto_id;

-- RIGHT JOIN
SELECT p.pedido_id, pr.nome, pp.quantidade
FROM pedido p
RIGHT JOIN pedido_produto pp ON p.pedido_id = pp.pedido_id
RIGHT JOIN produto pr ON pp.produto_id = pr.produto_id;

-- INNER JOIN
SELECT p.pedido_id, pg.metodo, pg.valor, pg.confirmado
FROM pedido p
INNER JOIN pagamento pg ON p.pedido_id = pg.pedido_id;

-- LEFT JOIN
SELECT p.pedido_id, pg.metodo, pg.valor, pg.confirmado
FROM pedido p
LEFT JOIN pagamento pg ON p.pedido_id = pg.pedido_id;

-- RIGHT JOIN
SELECT p.pedido_id, pg.metodo, pg.valor, pg.confirmado
FROM pedido p
RIGHT JOIN pagamento pg ON p.pedido_id = pg.pedido_id;

-- INNER JOIN
SELECT pr.nome AS produto, f.nome AS fornecedor
FROM produto pr
INNER JOIN fornecedor f ON f.fornecedor_id = pr.produto_id; -- apenas exemplo

-- LEFT JOIN
SELECT pr.nome AS produto, f.nome AS fornecedor
FROM produto pr
LEFT JOIN fornecedor f ON f.fornecedor_id = pr.produto_id;

-- RIGHT JOIN
SELECT pr.nome AS produto, f.nome AS fornecedor
FROM produto pr
RIGHT JOIN fornecedor f ON f.fornecedor_id = pr.produto_id;

UPDATE cliente SET telefone = NULL WHERE cliente_id IN (1,2,3);
UPDATE produto SET codigo = NULL WHERE produto_id IN (4,5);

