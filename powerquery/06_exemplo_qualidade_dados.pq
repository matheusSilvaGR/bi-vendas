// Demonstração de regras de qualidade para uma fonte externa potencialmente suja.
// Use em uma dimensão de clientes importada de staging, não nos CSVs finais gerados pelo Python.
let
    Origem = dim_cliente_origem,
    TextoLimpo = Table.TransformColumns(Origem, {
        {"nome", each Text.Proper(Text.Trim(_)), type text},
        {"segmento", each Text.Proper(Text.Trim(_)), type text},
        {"cidade", each Text.Proper(Text.Trim(_)), type text},
        {"estado", each Text.Upper(Text.Trim(_)), type text}}),
    SemNulosChave = Table.SelectRows(TextoLimpo, each [id_cliente] <> null and [nome] <> null),
    SemDuplicatas = Table.Distinct(SemNulosChave, {"id_cliente"})
in
    SemDuplicatas
