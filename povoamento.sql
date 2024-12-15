USE lojaConstrucaoAnalitico;

-- Preencher DimCliente
INSERT INTO DimCliente (id_cliente, nome, cidade, estado)
SELECT id_cliente, nome, cidade, estado
FROM lojaConstrucao.Cliente;

-- Preencher DimProduto
INSERT INTO DimProduto (id_produto, nome, preco)
SELECT id_produto, nome, preco
FROM lojaConstrucao.Produto;

-- Preencher DimCategoria
INSERT INTO DimCategoria (id_categoria, nome_categoria)
SELECT id_categoria, nome_categoria
FROM lojaConstrucao.Categoria;

-- Preencher DimTempo
INSERT INTO DimTempo (data, ano, mes, dia)
SELECT DISTINCT DATE(data_hora), YEAR(data_hora), MONTH(data_hora), DAY(data_hora)
FROM lojaConstrucao.Pedido;

-- Preencher FatoPedido
INSERT INTO FatoPedido (id_cliente, id_produto, id_categoria, id_tempo, quantidade_total, valor_total)
SELECT 
    p.id_cliente,
    ip.id_produto,
    pc.id_categoria,
    dt.id_tempo,
    ip.quantidade,
    ip.quantidade * pr.preco
FROM lojaConstrucao.Pedido p
JOIN lojaConstrucao.ItemPedido ip ON p.id_pedido = ip.id_pedido
JOIN lojaConstrucao.Produto pr ON ip.id_produto = pr.id_produto
JOIN lojaConstrucao.ProdutoCategoria pc ON pr.id_produto = pc.id_produto
JOIN DimTempo dt ON dt.data = DATE(p.data_hora);
