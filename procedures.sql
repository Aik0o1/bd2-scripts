USE lojaConstrucao;

-- Procedure para inserir Categorias
DELIMITER //
CREATE PROCEDURE InserirCategorias()
BEGIN
    DECLARE i INT DEFAULT 1;
    START TRANSACTION;
    
    WHILE i <= 60 DO
        INSERT INTO Categoria (nome_categoria) VALUES 
        (CONCAT('Categoria ', 
            CASE 
                WHEN i <= 15 THEN 'Materiais Básicos'
                WHEN i <= 30 THEN 'Ferramentas'
                WHEN i <= 45 THEN 'Acabamento'
                ELSE 'Elétrica e Hidráulica'
            END, 
            ' - ', i));
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure para inserir Produtos
DELIMITER //
CREATE PROCEDURE InserirProdutos()
BEGIN
    DECLARE i INT DEFAULT 1;
    START TRANSACTION;
    
    WHILE i <= 60 DO
        INSERT INTO Produto (nome, descricao, preco, quantidade) VALUES 
        (CONCAT('Produto ', 
            CASE 
                WHEN i <= 15 THEN 'Material Básico'
                WHEN i <= 30 THEN 'Ferramenta'
                WHEN i <= 45 THEN 'Item Acabamento'
                ELSE 'Componente Elétrico/Hidráulico'
            END, 
            ' - ', i),
         CONCAT('Descrição detalhada do produto ', i),
         ROUND(RAND() * 500 + 10, 2),  -- Preço entre 10 e 510
         ROUND(RAND() * 1000 + 50)     -- Quantidade entre 50 e 1050
        );
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure para inserir Clientes
DELIMITER //
CREATE PROCEDURE InserirClientes()
BEGIN
    DECLARE i INT DEFAULT 1;
    START TRANSACTION;
    
    WHILE i <= 60 DO
        INSERT INTO Cliente (
            nome, 
            email, 
            logradouro, 
            numero, 
            complemento, 
            bairro, 
            cidade, 
            estado, 
            cep
        ) VALUES 
        (CONCAT('Cliente ', i),
         CONCAT('cliente', i, '@exemplo.com'),
         CONCAT(
            CASE 
                WHEN i <= 20 THEN 'Rua '
                WHEN i <= 40 THEN 'Avenida '
                ELSE 'Travessa '
            END, 
            'Principal ', i
         ),
         FLOOR(1 + RAND() * 1000),  -- Número
         CASE 
            WHEN RAND() < 0.3 THEN CONCAT('Apartamento ', FLOOR(1 + RAND() * 50))
            WHEN RAND() < 0.6 THEN CONCAT('Bloco ', FLOOR(1 + RAND() * 10))
            ELSE NULL
         END,
         CONCAT('Bairro ', 
            CASE 
                WHEN i <= 20 THEN 'Centro'
                WHEN i <= 40 THEN 'Jardins'
                ELSE 'Industrial'
            END
         ),
         CASE 
            WHEN i <= 20 THEN 'Teresina'
            WHEN i <= 40 THEN 'Caxias'
            ELSE 'Timon'
         END,
         CASE 
            WHEN i <= 20 THEN 'PI'
            WHEN i <= 40 THEN 'MA'
            ELSE 'MA'
         END,
         CONCAT(
            FLOOR(10000 + RAND() * 90000),
            '-',
            FLOOR(100 + RAND() * 900)
         )
        );
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure auxiliar para gerar CEP formatado
DELIMITER //
CREATE FUNCTION GerarCEP() RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CONCAT(
        FLOOR(10000 + RAND() * 90000),
        '-',
        FLOOR(100 + RAND() * 900)
    );
END //
DELIMITER ;

-- Procedure para inserir Pedidos e ItemPedido
DELIMITER //
CREATE PROCEDURE InserirPedidosEItens()
BEGIN
    DECLARE i, cliente_id, num_itens, j INT;
    DECLARE valor_total DECIMAL(10,2) DEFAULT 0;
    
    START TRANSACTION;
    
    SET i = 1;
    WHILE i <= 100 DO
        -- Seleciona um cliente aleatório
        SET cliente_id = FLOOR(1 + RAND() * 60);
        
        -- Determina número de itens (mínimo 2, máximo 6)
        SET num_itens = FLOOR(2 + RAND() * 5);
        SET valor_total = 0;
        
        -- Insere o pedido
        INSERT INTO Pedido (id_cliente, data_hora, valor_total) VALUES 
        (cliente_id, 
         DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY), 
         0);  -- Valor total será calculado depois
        
        -- Pega o ID do pedido inserido
        SET @last_pedido_id = LAST_INSERT_ID();
        
        -- Insere itens do pedido
        SET j = 1;
        WHILE j <= num_itens DO
            -- Seleciona produto aleatório
            SET @produto_id = FLOOR(1 + RAND() * 60);
            
            -- Verifica se o produto já não foi inserido neste pedido
            IF NOT EXISTS (
                SELECT 1 FROM ItemPedido 
                WHERE id_pedido = @last_pedido_id AND id_produto = @produto_id
            ) THEN
                -- Recupera preço do produto
                SELECT preco INTO @preco_produto 
                FROM Produto 
                WHERE id_produto = @produto_id;
                
                -- Quantidade aleatória do item
                SET @quantidade = FLOOR(1 + RAND() * 10);
                
                -- Insere item do pedido
                INSERT INTO ItemPedido (id_pedido, id_produto, quantidade) 
                VALUES (@last_pedido_id, @produto_id, @quantidade);
                
                -- Atualiza valor total
                SET valor_total = valor_total + (@preco_produto * @quantidade);
                
                SET j = j + 1;
            END IF;
        END WHILE;
        
        -- Atualiza valor total do pedido
        UPDATE Pedido 
        SET valor_total = valor_total 
        WHERE id_pedido = @last_pedido_id;
        
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure para inserir associações de Produto e Categoria
DELIMITER //
CREATE PROCEDURE AssociarProdutoCategoria()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE categoria1 INT;
    DECLARE categoria2 INT;
    
    START TRANSACTION;
    
    WHILE i <= 60 DO
        -- Seleciona primeira categoria
        SET categoria1 = FLOOR(1 + RAND() * 60);
        
        -- Seleciona segunda categoria diferente da primeira
        REPEAT
            SET categoria2 = FLOOR(1 + RAND() * 60);
        UNTIL categoria2 != categoria1 END REPEAT;
        
        -- Insere primeira categoria
        INSERT IGNORE INTO ProdutoCategoria (id_produto, id_categoria) 
        VALUES (i, categoria1);
        
        -- Insere segunda categoria
        INSERT IGNORE INTO ProdutoCategoria (id_produto, id_categoria) 
        VALUES (i, categoria2);
        
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END //
DELIMITER ;
-- Procedure principal para executar todas as inserções
DELIMITER //
CREATE PROCEDURE PopularBancoDeDados()
BEGIN
    CALL InserirCategorias();
    CALL InserirProdutos();
    CALL InserirClientes();
    CALL InserirPedidosEItens();
    CALL AssociarProdutoCategoria();
END //
DELIMITER ;
CALL PopularBancoDeDados();