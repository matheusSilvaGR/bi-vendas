// Tabela Calendário (marque como tabela de datas e relacione com vw_vendas[data_venda]).
let
    Inicio = #date(2023,1,1),
    Fim = #date(2025,12,31),
    Datas = List.Dates(Inicio, Duration.Days(Fim - Inicio) + 1, #duration(1,0,0,0)),
    Tabela = Table.FromList(Datas, Splitter.SplitByNothing(), {"Data"}, null, ExtraValues.Error),
    Tipada = Table.TransformColumnTypes(Tabela, {{"Data", type date}}),
    Ano = Table.AddColumn(Tipada, "Ano", each Date.Year([Data]), Int64.Type),
    MesNum = Table.AddColumn(Ano, "MesNum", each Date.Month([Data]), Int64.Type),
    Mes = Table.AddColumn(MesNum, "Mes", each Text.Start(Date.MonthName([Data], "pt-BR"), 3), type text),
    Trim = Table.AddColumn(Mes, "Trimestre", each "T" & Text.From(Date.QuarterOfYear([Data])), type text),
    AnoMes = Table.AddColumn(Trim, "AnoMes", each Date.ToText([Data], "yyyy-MM"), type text)
in
    AnoMes
