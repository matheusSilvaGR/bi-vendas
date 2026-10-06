// OPÇÃO C: PostgreSQL.
let
    Origem = PostgreSQL.Database("localhost:5432", "vendasbi"),
    Vendas = Origem{[Schema="public", Item="vw_vendas"]}[Data]
in
    Vendas
