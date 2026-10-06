// MODELO ESTRELA VIA CSV
// Crie uma consulta em branco para cada tabela abaixo e use o bloco correspondente.
// Ajuste PastaDados para a pasta /data do projeto.

// === Consulta: fato_vendas ===
let
    PastaDados = "C:\\bi-vendas\\data\\",
    Origem = Csv.Document(File.Contents(PastaDados & "fato_vendas.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Cabecalho = Table.PromoteHeaders(Origem, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {{"id_venda", Int64.Type}, {"data_venda", type date}, {"id_cliente", Int64.Type}, {"id_produto", Int64.Type}, {"id_loja", Int64.Type}, {"quantidade", Int64.Type}, {"desconto_pct", type number}, {"valor_bruto", Currency.Type}, {"valor_liquido", Currency.Type}}, "en-US")
in Tipos

// Repita a importação para dim_cliente.csv, dim_produto.csv, dim_loja.csv e dim_meta.csv.
// Para as dimensões, promova cabeçalhos e defina IDs/ano como Int64.Type e valores monetários como Currency.Type.
// A view vw_vendas.csv é opcional e deve ser usada somente para conferência, não como tabela principal do modelo.
