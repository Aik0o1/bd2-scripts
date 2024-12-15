USE lojaConstrucaoAnalitico;

-- Utilizado no K-means
-- seleção para clientes, suas compras e onde foram feitas
SELECT 
    c.id_cliente,
    c.nome,
    COUNT(f.id_fato) AS total_compras,
    SUM(f.valor_total) AS total_gasto,
    c.cidade,
    c.estado
FROM 
    DimCliente c
JOIN 
    FatoPedido f ON c.id_cliente = f.id_cliente
GROUP BY 
    c.id_cliente, c.nome, c.cidade, c.estado;

-- Utilizado no K-means
-- seleção para produtos, suas categorias, total de vendas e receita gerada
SELECT 
    dc.nome_categoria,
    dp.nome AS nome_produto,
    SUM(fp.quantidade_total) AS total_vendido,
    SUM(fp.valor_total) AS receita_gerada
FROM 
    FatoPedido fp
JOIN 
    DimProduto dp ON fp.id_produto = dp.id_produto
JOIN 
    DimCategoria dc ON fp.id_categoria = dc.id_categoria
GROUP BY 
    dc.nome_categoria, dp.nome
ORDER BY 
    receita_gerada DESC;

-- Utilizado na regressão linear
-- seleção para informaçoes de compra de produto, quantidade comprada, valor total, preco individual do produto, ano e estado onde foi comprado 
SELECT 
    fp.quantidade_total,
    fp.valor_total,
    dp.preco AS preco_produto,
    dt.ano,
    fc.estado
FROM 
    FatoPedido fp
JOIN DimCliente fc ON fp.id_cliente = fc.id_cliente
JOIN DimProduto dp ON fp.id_produto = dp.id_produto
JOIN DimTempo dt ON fp.id_tempo = dt.id_tempo;
