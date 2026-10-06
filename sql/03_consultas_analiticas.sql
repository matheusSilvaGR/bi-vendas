-- Consultas de validação: use para conferir os números do dashboard.

-- 1) Receita, lucro e margem por mês
SELECT substr(data_venda,1,7) AS mes,
       ROUND(SUM(valor_liquido),2) AS receita,
       ROUND(SUM(lucro),2)         AS lucro,
       ROUND(100.0*SUM(lucro)/SUM(valor_liquido),1) AS margem_pct
FROM vw_vendas GROUP BY mes ORDER BY mes;

-- 2) Top 5 produtos por receita
SELECT produto, ROUND(SUM(valor_liquido),2) AS receita
FROM vw_vendas GROUP BY produto ORDER BY receita DESC LIMIT 5;

-- 3) Receita por região e canal
SELECT regiao, canal, ROUND(SUM(valor_liquido),2) AS receita
FROM vw_vendas GROUP BY regiao, canal ORDER BY regiao, receita DESC;

-- 4) Crescimento ano contra ano (janelas)
WITH anual AS (
  SELECT substr(data_venda,1,4) AS ano, SUM(valor_liquido) AS receita
  FROM vw_vendas GROUP BY ano)
SELECT ano, ROUND(receita,2) AS receita,
       ROUND(100.0*(receita - LAG(receita) OVER (ORDER BY ano))
             / LAG(receita) OVER (ORDER BY ano),1) AS crescimento_pct
FROM anual;

-- 5) Curva ABC de clientes (acumulado da receita)
WITH r AS (
  SELECT cliente, SUM(valor_liquido) AS receita FROM vw_vendas GROUP BY cliente),
t AS (
  SELECT cliente, receita,
         SUM(receita) OVER (ORDER BY receita DESC) * 1.0 / SUM(receita) OVER () AS acum
  FROM r)
SELECT cliente, ROUND(receita,2) AS receita, ROUND(100*acum,1) AS acumulado_pct,
       CASE WHEN acum <= 0.8 THEN 'A' WHEN acum <= 0.95 THEN 'B' ELSE 'C' END AS classe
FROM t ORDER BY receita DESC LIMIT 20;
