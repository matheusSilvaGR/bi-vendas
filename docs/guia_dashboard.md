# Guia de montagem do dashboard no Power BI

## 1. Gerar a base

Execute `python gerar_dados.py` na raiz do projeto.

## 2. Importar o Star Schema

No Power BI Desktop, importe os CSVs separadamente:

- `fato_vendas.csv`
- `dim_cliente.csv`
- `dim_produto.csv`
- `dim_loja.csv`
- `dim_meta.csv`

Crie `Calendario` com `powerquery/05_calendario.pq`. Não use `vw_vendas` como tabela principal; ela serve apenas para conferência SQL.

## 3. Relacionamentos

Configure relacionamentos 1:N e filtro simples das dimensões para a fato:

```text
dim_cliente[id_cliente] -> fato_vendas[id_cliente]
dim_produto[id_produto] -> fato_vendas[id_produto]
dim_loja[id_loja]       -> fato_vendas[id_loja]
Calendario[Data]         -> fato_vendas[data_venda]
```

Para metas, relacione `dim_meta[ano]` a `Calendario[Ano]`. Marque `Calendario` como tabela de datas.

## 4. Tratamento

Use `04_tratamento_vendas.pq` como referência para validação da fato. `06_exemplo_qualidade_dados.pq` é um exemplo separado de tratamento de uma fonte de staging potencialmente suja.

## 5. Medidas

Crie uma tabela exclusiva para medidas e copie `dax/medidas.dax`. As medidas agora calculam lucro a partir da fato + custo da dimensão produto e usam `dim_meta` para metas anuais.

## 6. Páginas sugeridas

### Visão Executiva
Cartões de Receita, Lucro, Margem %, Ticket Médio e Crescimento YoY %. Inclua tendência mensal, receita por categoria e Atingimento da Meta %. Segmentações: Ano, Região e Canal.

### Produtos e Categorias
Top produtos por Receita, matriz Categoria × Produto, Margem %, participação dentro da categoria e ranking.

### Clientes e Regiões
Receita por Estado/Região, Top clientes e Receita por Segmento.

### Tendência e Sazonalidade
Receita YTD versus ano anterior, Variação MoM % e Média Móvel 3M.

## 7. Validação

Confira os cartões contra os números do README. A receita total deve ser R$ 3.808.642,60, o lucro R$ 1.926.267,60 e a quantidade de vendas 8.525.

## 8. Publicação no GitHub

Depois de montar o dashboard, salve o `.pbix` em `dashboard/` e exporte screenshots das quatro páginas para `images/`. Coloque a Visão Executiva no início do README para que recrutadores vejam o resultado sem precisar abrir o Power BI.
