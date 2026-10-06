# Business Intelligence de Vendas | Power BI, SQL, DAX e Python

Projeto de BI ponta a ponta com **modelo dimensional em Star Schema**, geração reproduzível de dados com Python, camada SQL analítica, transformação com Power Query e medidas DAX para análise comercial.

> Os dados são fictícios. O projeto foi estruturado para demonstrar competências de BI e análise de dados de forma reproduzível e auditável.

**Stack:** Power BI · SQL · Power Query (M) · DAX · Python · SQLite

## Arquitetura

```text
                    dim_cliente
                         |
dim_produto ---- fato_vendas ---- dim_loja
                         |
                     Calendario
                         |
                 (filtro por data)

Calendario[Ano] ---- dim_meta[Ano]
```

A `vw_vendas` permanece no SQLite apenas como **camada auxiliar para consultas SQL e validação dos resultados**. O modelo recomendado no Power BI utiliza fato e dimensões separadamente.

## Estrutura

```text
bi-vendas/
├── gerar_dados.py
├── data/
│   ├── fato_vendas.csv
│   ├── dim_cliente.csv
│   ├── dim_produto.csv
│   ├── dim_loja.csv
│   ├── dim_meta.csv
│   ├── vw_vendas.csv
│   └── vendas.db
├── sql/
│   ├── 01_schema.sql
│   ├── 02_views.sql
│   └── 03_consultas_analiticas.sql
├── powerquery/
│   ├── 01_conexao_csv.pq
│   ├── 04_tratamento_vendas.pq
│   ├── 05_calendario.pq
│   └── 06_exemplo_qualidade_dados.pq
├── dax/medidas.dax
└── docs/guia_dashboard.md
```

## Como executar

```bash
python gerar_dados.py
```

O script recria a base SQLite e os CSVs usando uma seed fixa. Não há dependências Python externas.

## Modelo no Power BI

Importe separadamente `fato_vendas`, `dim_cliente`, `dim_produto`, `dim_loja` e `dim_meta`. Crie também `Calendario` usando `powerquery/05_calendario.pq`.

Crie os relacionamentos 1:N:

```text
dim_cliente[id_cliente]  1 -> * fato_vendas[id_cliente]
dim_produto[id_produto]  1 -> * fato_vendas[id_produto]
dim_loja[id_loja]        1 -> * fato_vendas[id_loja]
Calendario[Data]          1 -> * fato_vendas[data_venda]
Calendario[Ano]           * -> 1 dim_meta[ano]
```

Use direção de filtro simples das dimensões para a fato. A `vw_vendas` não é necessária para o dashboard.

## Indicadores de referência

Com a seed padrão:

| Indicador | Valor |
|---|---:|
| Receita | R$ 3.808.642,60 |
| Lucro | R$ 1.926.267,60 |
| Vendas | 8.525 |
| Receita 2023 | R$ 1.105.295,05 |
| Receita 2024 | R$ 1.271.814,70 |
| Receita 2025 | R$ 1.431.532,85 |
| Crescimento 2024 | +15,1% |
| Crescimento 2025 | +12,6% |

As metas anuais de exemplo são armazenadas em `dim_meta`, e não mais codificadas diretamente em uma medida DAX.

## Competências demonstradas

- **Modelagem dimensional:** fato, dimensões, chaves e relacionamentos 1:N.
- **Python:** geração de dados fictícios reproduzíveis e carga automatizada no SQLite/CSV.
- **SQL:** joins, views, CTEs, funções de janela, análises temporais e Curva ABC.
- **Power Query:** tipagem, validação de regras de negócio, deduplicação e exemplo de tratamento de staging.
- **DAX:** `CALCULATE`, `RELATED`, `REMOVEFILTERS`, `RANKX`, YTD, YoY, MoM, média móvel e metas dinâmicas.
- **BI:** KPIs executivos, análise de produtos, clientes, regiões, sazonalidade e desempenho versus meta.

## Qualidade dos dados

Os dados finais produzidos pelo Python já obedecem às regras de integridade. `04_tratamento_vendas.pq` mantém validações defensivas sobre a fato. O arquivo `06_exemplo_qualidade_dados.pq` demonstra como tratar uma fonte de staging externa com espaços, capitalização inconsistente, nulos de chave e duplicidades — sem alegar que esses problemas existem artificialmente na base final.

## Dashboard

O arquivo `.pbix` deve ser criado no Power BI Desktop seguindo `docs/guia_dashboard.md`. Para apresentação no GitHub, recomenda-se adicionar posteriormente:

```text
dashboard/bi_vendas.pbix
images/visao_executiva.png
images/produtos.png
images/clientes.png
images/tendencias.png
```

## Limitações

- O `.pbix` não pode ser gerado de forma confiável fora do Power BI Desktop.
- Os scripts DAX/M devem ser validados no Power BI usando os indicadores de referência acima.
- Os dados são fictícios e não representam uma empresa real.
