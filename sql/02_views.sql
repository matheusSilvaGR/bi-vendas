-- View desnormalizada para consumo direto (Import ou DirectQuery)
CREATE VIEW vw_vendas AS
SELECT
    f.id_venda,
    f.data_venda,
    c.nome        AS cliente,
    c.segmento,
    c.cidade,
    c.estado,
    p.nome        AS produto,
    p.categoria,
    l.nome        AS loja,
    l.regiao,
    l.canal,
    f.quantidade,
    f.desconto_pct,
    f.valor_bruto,
    f.valor_liquido,
    f.valor_liquido - (f.quantidade * p.custo_unit) AS lucro
FROM fato_vendas f
JOIN dim_cliente c ON c.id_cliente = f.id_cliente
JOIN dim_produto p ON p.id_produto = f.id_produto
JOIN dim_loja    l ON l.id_loja    = f.id_loja;
