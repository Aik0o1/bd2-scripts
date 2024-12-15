CREATE DATABASE lojaConstrucao;
USE lojaConstrucao;

-- Tabela Produto
CREATE TABLE Produto (
    id_produto INT PRIMARY KEY auto_increment,
    nome VARCHAR(255),
    descricao TEXT,
    preco DECIMAL(10, 2),
    quantidade INT
);

-- Tabela Categoria
CREATE TABLE Categoria (
    id_categoria INT PRIMARY KEY auto_increment,
    nome_categoria VARCHAR(100)
);

-- Tabela de associação ProdutoCategoria
CREATE TABLE ProdutoCategoria (
    id_produto INT,
    id_categoria INT,
    PRIMARY KEY (id_produto, id_categoria),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- Tabela Cliente
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY auto_increment,
    nome VARCHAR(255),
    email VARCHAR(255),
	logradouro VARCHAR(255),
	numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
	cidade VARCHAR(100),
	estado VARCHAR(2),
    cep VARCHAR(10)
);

-- Tabela Pedido
CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY auto_increment,
    id_cliente INT,
    data_hora DATETIME,
    valor_total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabela de associação ItemPedido
CREATE TABLE ItemPedido (
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);