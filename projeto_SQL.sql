CREATE TABLE cliente(
    id_cliente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    telefone VARCHAR2(15),
    email VARCHAR2(100),
    data_cadastro DATE DEFAULT SYSDATE
);

CREATE TABLE funcionario (
    id_funcionario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    cargo VARCHAR2(50) NOT NULL,
    telefone VARCHAR2(15),
    data_admissao DATE NOT NULL
);

CREATE TABLE categoria (
    id_categoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(50) NOT NULL UNIQUE,
    descricao VARCHAR2(150),
    ativa CHAR(1) DEFAULT 'S' CHECK (ativa IN ('S','N'))
);

CREATE TABLE produto (
    id_produto NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(80) NOT NULL,
    descricao VARCHAR2(150),
    preco NUMBER(8,2) NOT NULL CHECK (preco > 0),
    estoque NUMBER(5) DEFAULT 0,
    id_categoria NUMBER NOT NULL,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);

CREATE TABLE pedido (
    id_pedido NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_hora DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ABERTO',
    forma_pagamento VARCHAR(20),
    valor_total NUMBER(10,2) DEFAULT 0,
    id_cliente NUMBER,
    id_funcionario NUMBER NOT NULL,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_pedido_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

CREATE TABLE item_pedido(
    id_item NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido NUMBER NOT NULL,
    id_produto NUMBER NOT NULL,
    quantidade NUMBER(3) NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMBER(8,2) NOT NULL,
    CONSTRAINT uq_item_pedido UNIQUE (id_pedido, id_produto),
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

INSERT INTO categoria (nome, descricao, ativa) VALUES ('Pastéis salgados', 'Pastéis fritos com recheios salgados', 'S');
INSERT INTO categoria (nome, descricao, ativa) VALUES ('Pastéis doces', 'Pastéis fritos com recheios doces', 'S');
INSERT INTO categoria (nome, descricao, ativa) VALUES ('Bebidas', 'Caldo de cana, sucos e refrigerantes', 'S');

INSERT INTO produto (nome, descricao, preco, estoque, id_categoria) VALUES ('Pastel de carne', 'Carne moída temperada', 9.00, 50, 1);
INSERT INTO produto (nome, descricao, preco, estoque, id_categoria) VALUES ('Pastel de chocolate', 'Recheio de chocolate ao leite', 10.00, 30, 2);
INSERT INTO produto (nome, descricao, preco, estoque, id_categoria) VALUES ('Caldo de cana 500ml', 'Caldo de cana gelado', 7.00, 80, 3);

INSERT INTO cliente (nome, telefone, email) VALUES ('Maria Silva', '11987654321', 'maria.silva@email.com');
INSERT INTO cliente (nome, telefone, email, data_cadastro) VALUES ('João Souza', '11976543210', 'joao.souza@email.com', TO_DATE('2026-09-20', 'YYYY-MM-DD'));
INSERT INTO cliente (nome, telefone, email, data_cadastro) VALUES ('Ana Oliveira', '11965432109', 'ana.oliveira@email.com', TO_DATE('2026-10-01', 'YYYY-MM-DD'));

INSERT INTO funcionario (nome, cargo, telefone, data_admissao) VALUES ('Carlos Pereira', 'Pasteleiro', '11954321098', TO_DATE('2025-03-10', 'YYYY-MM-DD'));
INSERT INTO funcionario (nome, cargo, telefone, data_admissao) VALUES ('Fernanda Lima', 'Atendente', '11943210987', TO_DATE('2025-06-01', 'YYYY-MM-DD'));
INSERT INTO funcionario (nome, cargo, telefone, data_admissao) VALUES ('Roberto Alves', 'Caixa', '11932109876', TO_DATE('2026-01-15', 'YYYY-MM-DD'));

INSERT INTO pedido (data_hora, status, forma_pagamento, valor_total, id_cliente, id_funcionario)
VALUES (TO_DATE('2026-10-10 12:30', 'YYYY-MM-DD HH24:MI'), 'FINALIZADO', 'PIX', 25.00, 1, 2);
INSERT INTO pedido (data_hora, status, forma_pagamento, valor_total, id_cliente, id_funcionario)
VALUES (TO_DATE('2026-10-11 18:15', 'YYYY-MM-DD HH24:MI'), 'FINALIZADO', 'DINHEIRO', 17.00, 2, 3);
INSERT INTO pedido (data_hora, status, forma_pagamento, valor_total, id_cliente, id_funcionario)
VALUES (TO_DATE('2026-10-12 19:40', 'YYYY-MM-DD HH24:MI'), 'ABERTO', 'CARTAO', 27.00, NULL, 2);

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES (1, 1, 2, 9.00);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES (1, 3, 1, 7.00);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES (2, 2, 1, 10.00);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES (2, 3, 1, 7.00);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES (3, 1, 3, 9.00);

SELECT * FROM categoria;
SELECT * FROM produto;
SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM pedido;
SELECT * FROM item_pedido;

SELECT p.id_pedido, TO_CHAR(p.data_hora, 'DD/MM/YYYY HH24:MI')AS data_pedido,
NVL(c.nome, 'Cliente de balcão') AS cliente,
f.nome AS atendente, 
pr.nome AS produto, 
ip.quantidade, 
ip.preco_unitario, 
ip.quantidade * ip.preco_unitario AS subtotal 
FROM pedido p 
LEFT JOIN cliente c ON c.id_cliente = p.id_cliente 
INNER JOIN funcionario f ON f.id_funcionario = p.id_funcionario 
INNER JOIN item_pedido ip ON ip.id_pedido = p.id_pedido 
INNER JOIN produto pr ON pr.id_produto = ip.id_produto ORDER BY p.id_pedido, pr.nome; 