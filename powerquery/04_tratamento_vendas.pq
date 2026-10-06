// Tratamento da tabela fato. Nomeie a consulta bruta como "fato_vendas_origem".
let
    Origem = fato_vendas_origem,
    Tipos = Table.TransformColumnTypes(Origem, {
        {"id_venda", Int64.Type}, {"data_venda", type date},
        {"id_cliente", Int64.Type}, {"id_produto", Int64.Type}, {"id_loja", Int64.Type},
        {"quantidade", Int64.Type}, {"desconto_pct", type number},
        {"valor_bruto", Currency.Type}, {"valor_liquido", Currency.Type}}),
    SemDuplicatas = Table.Distinct(Tipos, {"id_venda"}),
    Validas = Table.SelectRows(SemDuplicatas, each
        [quantidade] > 0 and [valor_bruto] >= 0 and [valor_liquido] >= 0 and
        [desconto_pct] >= 0 and [desconto_pct] <= 0.5),
    Faixa = Table.AddColumn(Validas, "faixa_desconto", each
        if [desconto_pct] = 0 then "Sem desconto"
        else if [desconto_pct] <= 0.10 then "Até 10%"
        else "Acima de 10%", type text)
in
    Faixa
