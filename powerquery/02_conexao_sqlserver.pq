// OPÇÃO B: SQL Server (carregue o schema antes; ajuste tipos: TEXT->NVARCHAR, REAL->DECIMAL(12,2), data_venda->DATE).
let
    Origem = Sql.Database("localhost", "VendasBI"),
    Vendas = Origem{[Schema="dbo", Item="vw_vendas"]}[Data]
in
    Vendas
