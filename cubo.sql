-- Criar banco de dados analítico
CREATE DATABASE IF NOT EXISTS lojaConstrucaoAnalitico;
USE lojaConstrucaoAnalitico;

-- Dimensão Cliente
CREATE TABLE DimCliente (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(255),
    cidade VARCHAR(100),
    estado VARCHAR(2)
);

-- Dimensão Produto
CREATE TABLE DimProduto (
    id_produto INT PRIMARY KEY,
    nome VARCHAR(255),
    preco DECIMAL(10, 2)
);

-- Dimensão Categoria
CREATE TABLE DimCategoria (
    id_categoria INT PRIMARY KEY,
    nome_categoria VARCHAR(100)
);

-- Dimensão Tempo
CREATE TABLE DimTempo (
    id_tempo INT PRIMARY KEY AUTO_INCREMENT,
    data DATE,
    ano INT,
    mes INT,
    dia INT
);

-- Tabela Fato
CREATE TABLE FatoPedido (
    id_fato INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_produto INT,
    id_categoria INT,
    id_tempo INT,
    quantidade_total INT,
    valor_total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES DimCliente(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES DimProduto(id_produto),
    FOREIGN KEY (id_categoria) REFERENCES DimCategoria(id_categoria),
    FOREIGN KEY (id_tempo) REFERENCES DimTempo(id_tempo)
);
