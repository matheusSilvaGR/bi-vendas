-- Modelo dimensional (star schema) para análise de vendas no Power BI
-- Compatível com SQLite; para SQL Server/PostgreSQL ver docs/ (ajustes de tipo no README).
DROP VIEW IF EXISTS vw_vendas;
DROP TABLE IF EXISTS fato_vendas;
DROP TABLE IF EXISTS dim_meta;
DROP TABLE IF EXISTS dim_cliente;
DROP TABLE IF EXISTS dim_produto;
DROP TABLE IF EXISTS dim_loja;

CREATE TABLE dim_cliente (
    id_cliente   INTEGER PRIMARY KEY,
    nome         TEXT NOT NULL,
    segmento     TEXT NOT NULL,          -- Varejo, Corporativo, Premium
    cidade       TEXT NOT NULL,
    estado       TEXT NOT NULL
);

CREATE TABLE dim_produto (
    id_produto   INTEGER PRIMARY KEY,
    nome         TEXT NOT NULL,
    categoria    TEXT NOT NULL,
    custo_unit   REAL NOT NULL,
    preco_unit   REAL NOT NULL
);

CREATE TABLE dim_loja (
    id_loja      INTEGER PRIMARY KEY,
    nome         TEXT NOT NULL,
    regiao       TEXT NOT NULL,
    canal        TEXT NOT NULL           -- Loja física, E-commerce
);

CREATE TABLE dim_meta (
    ano          INTEGER PRIMARY KEY,
    meta_receita REAL NOT NULL CHECK (meta_receita > 0)
);

CREATE TABLE fato_vendas (
    id_venda     INTEGER PRIMARY KEY,
    data_venda   TEXT NOT NULL,          -- ISO yyyy-mm-dd
    id_cliente   INTEGER NOT NULL REFERENCES dim_cliente(id_cliente),
    id_produto   INTEGER NOT NULL REFERENCES dim_produto(id_produto),
    id_loja      INTEGER NOT NULL REFERENCES dim_loja(id_loja),
    quantidade   INTEGER NOT NULL CHECK (quantidade > 0),
    desconto_pct REAL NOT NULL DEFAULT 0 CHECK (desconto_pct BETWEEN 0 AND 0.5),
    valor_bruto  REAL NOT NULL,          -- quantidade * preco_unit
    valor_liquido REAL NOT NULL          -- valor_bruto * (1 - desconto_pct)
);

CREATE INDEX ix_fato_data    ON fato_vendas(data_venda);
CREATE INDEX ix_fato_cliente ON fato_vendas(id_cliente);
CREATE INDEX ix_fato_produto ON fato_vendas(id_produto);
CREATE INDEX ix_fato_loja    ON fato_vendas(id_loja);
