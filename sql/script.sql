-- Criando a tabela clientes
CREATE TABLE clientes (
    id_cliente INTEGER PRIMARY KEY, -- Identificador único
    nome TEXT NOT NULL,             -- Nome completo do cliente
    cpf TEXT UNIQUE NOT NULL        -- CPF (único para cada cliente)
);

-- Criando a tabela contas
CREATE TABLE contas (
    id_conta INTEGER PRIMARY KEY,   -- Identificador único da conta
    id_cliente INTEGER NOT NULL,    -- Relaciona conta ao cliente (chave estrangeira)
    agencia TEXT NOT NULL,          -- Número da agência
    numero_conta TEXT NOT NULL,     -- Número da conta
    saldo REAL DEFAULT 0,           -- Saldo da conta
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Criando a tabela transações
CREATE TABLE transacoes (
    id_transacao INTEGER PRIMARY KEY,                       -- Identificador único da transação
    id_conta INTEGER NOT NULL,                              -- Conta vinculada à transação
    tipo TEXT CHECK(tipo IN ('entrada', 'saida')),          -- Tipo de transação (entrada ou saída)
    valor REAL NOT NULL,                                    -- Valor da transação
    data TEXT NOT NULL,                                     -- Data da transação (YYYY-MM-DD)
    descricao TEXT,                                         -- Descrição opcional
    FOREIGN KEY (id_conta) REFERENCES contas(id_conta)
);

-- Inserindo 20 clientes na tabela clientes
INSERT INTO clientes (nome, cpf) VALUES
('Maria Souza', '111.111.111-11'),
('João Lima', '222.222.222-22'),
('Ana Paula', '333.333.333-33'),
('Carlos Alberto', '444.444.444-44'),
('Fernanda Lima', '555.555.555-55'),
('Ricardo Gomes', '666.666.666-66'),
('Beatriz Moura', '777.777.777-77'),
('Eduardo Alves', '888.888.888-88'),
('Juliana Costa', '999.999.999-99'),
('Paulo Henrique', '101.101.101-10'),
('Sofia Martins', '202.202.202-20'),
('Gustavo Ferreira', '303.303.303-30'),
('Camila Rocha', '404.404.404-40'),
('André Nunes', '505.505.505-50'),
('Patrícia Dias', '606.606.606-60'),
('Felipe Santos', '707.707.707-70'),
('Larissa Pires', '808.808.808-80'),
('Lucas Mendes', '909.909.909-90'),
('Viviane Castro', '121.121.121-12'),
('Rafael Oliveira', '232.232.232-23');

-- Inserindo contas vinculadas aos clientes (multicontas)
INSERT INTO contas (id_cliente, agencia, numero_conta, saldo) VALUES
(1, '0001', '12345-6', 1500),
(1, '0002', '23456-7', 2000),
(2, '0001', '34567-8', 500),
(3, '0003', '45678-9', 300),
(4, '0001', '56789-0', 800),
(4, '0004', '67890-1', 1200),
(5, '0002', '78901-2', 2500),
(6, '0003', '89012-3', 150),
(7, '0001', '90123-4', 700),
(8, '0005', '11223-4', 950),
(9, '0001', '22334-5', 120),
(10, '0002', '33445-6', 450),
(11, '0003', '44556-7', 980),
(12, '0001', '55667-8', 1340),
(13, '0004', '66778-9', 4000),
(14, '0001', '77889-0', 600),
(15, '0002', '88990-1', 7000),
(16, '0005', '99001-2', 8500),
(17, '0001', '10112-3', 150),
(18, '0003', '20223-4', 250),
(19, '0002', '30334-5', 900),
(20, '0004', '40445-6', 5000);

-- Inserindo transações para movimentar as contas
INSERT INTO transacoes (id_conta, tipo, valor, data, descricao) VALUES
(1, 'entrada', 500, '2025-08-01', 'Depósito'),
(1, 'saida', 200, '2025-08-02', 'Saque'),
(2, 'entrada', 1000, '2025-08-02', 'Transferência'),
(3, 'saida', 100, '2025-08-01', 'Débito automático'),
(4, 'entrada', 300, '2025-08-03', 'PIX'),
(5, 'entrada', 700, '2025-08-01', 'Depósito'),
(5, 'saida', 200, '2025-08-02', 'Pagamento conta'),
(6, 'entrada', 1200, '2025-08-03', 'TED'),
(7, 'saida', 50, '2025-08-01', 'Tarifa bancária'),
(8, 'entrada', 250, '2025-08-02', 'PIX'),
(9, 'saida', 20, '2025-08-01', 'Tarifa bancária'),
(10, 'entrada', 500, '2025-08-01', 'Depósito'),
(11, 'entrada', 800, '2025-08-02', 'Venda produto'),
(12, 'saida', 150, '2025-08-02', 'Pagamento conta'),
(13, 'entrada', 2500, '2025-08-03', 'Aplicação resgatada'),
(14, 'saida', 400, '2025-08-02', 'Saque'),
(15, 'entrada', 3500, '2025-08-01', 'Bônus'),
(16, 'saida', 1000, '2025-08-02', 'Compra parcelada'),
(17, 'entrada', 250, '2025-08-01', 'PIX'),
(18, 'entrada', 700, '2025-08-03', 'Depósito');

-- Criando uma view para facilitar consultas do saldo total por cliente
CREATE VIEW vw_saldo_total AS
SELECT 
    c.id_cliente,
    c.nome,
    SUM(ct.saldo) AS saldo_total
FROM clientes c
JOIN contas ct ON c.id_cliente = ct.id_cliente
GROUP BY c.id_cliente;

-- Exemplos de consultas com filtros

-- Clientes com saldo maior que 2000
SELECT * FROM vw_saldo_total WHERE saldo_total > 2000;

-- Clientes que começam com a letra M
SELECT * FROM clientes WHERE nome LIKE 'M%';

-- Contas com saldo entre 500 e 2000
SELECT * FROM contas WHERE saldo BETWEEN 500 AND 2000;

-- Clientes com id 1, 5 e 10
SELECT * FROM clientes WHERE id_cliente IN (1,5,10);

-- Quantidade de contas por cliente
SELECT 
    c.nome,
    COUNT(ct.id_conta) AS qtd_contas
FROM clientes c
JOIN contas ct ON c.id_cliente = ct.id_cliente
GROUP BY c.id_cliente
ORDER BY qtd_contas DESC;

-- Média do saldo total dos clientes
SELECT AVG(saldo_total) AS media_saldo FROM vw_saldo_total;

-- Classificando com CASE

-- Classificar clientes por categoria de saldo
SELECT 
    nome,
    saldo_total,
    CASE 
        WHEN saldo_total >= 5000 THEN 'Cliente VIP' -- Quando o saldo total do cliente for maior que 5000 será denominado como Cliente Vip
        WHEN saldo_total >= 2000 THEN 'Cliente Ouro' -- Quando o saldo total do cliente for maior que 5000 será denominado como Cliente Ouro
        ELSE 'Cliente Comum' -- Quando o saldo total do cliente for menor que 2000 será denominado como Cliente Comum
    END AS categoria
FROM vw_saldo_total
ORDER BY saldo_total DESC;
