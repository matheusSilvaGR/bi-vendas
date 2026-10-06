"""Gera uma base FICTÍCIA de vendas (SQLite + CSVs). Seed fixa => resultado reproduzível."""
import csv
import random
import sqlite3
from datetime import date, timedelta
from pathlib import Path

ROOT = Path(__file__).parent
DB = ROOT / "data" / "vendas.db"
random.seed(42)

CIDADES = [("São Paulo", "SP", "Sudeste"), ("Rio de Janeiro", "RJ", "Sudeste"),
           ("Belo Horizonte", "MG", "Sudeste"), ("Curitiba", "PR", "Sul"),
           ("Porto Alegre", "RS", "Sul"), ("Salvador", "BA", "Nordeste"),
           ("Recife", "PE", "Nordeste"), ("Brasília", "DF", "Centro-Oeste"),
           ("Manaus", "AM", "Norte")]
PRIMEIROS = ["Ana", "Bruno", "Carla", "Diego", "Elisa", "Fábio", "Gabriela", "Hugo",
             "Isabela", "João", "Karen", "Lucas", "Marina", "Nicolas", "Olívia", "Paulo"]
SOBRENOMES = ["Silva", "Souza", "Oliveira", "Santos", "Lima", "Pereira", "Costa", "Ribeiro"]
PRODUTOS = {  # categoria: [(nome, custo, preço)]
    "Eletrônicos": [("Fone Bluetooth", 80, 159), ("Smartwatch", 220, 449), ("Carregador Rápido", 25, 69)],
    "Casa": [("Cafeteira", 90, 189), ("Liquidificador", 70, 149), ("Jogo de Panelas", 130, 279)],
    "Moda": [("Tênis Esportivo", 110, 259), ("Mochila", 60, 139), ("Jaqueta", 120, 299)],
    "Esporte": [("Bicicleta Ergométrica", 600, 1199), ("Kit Halteres", 90, 199), ("Tapete de Yoga", 30, 79)],
}
LOJAS = [("Loja Paulista", "Sudeste", "Loja física"), ("Loja Carioca", "Sudeste", "Loja física"),
         ("Loja Sul", "Sul", "Loja física"), ("Loja Nordeste", "Nordeste", "Loja física"),
         ("Loja Capital", "Centro-Oeste", "Loja física"), ("E-commerce Brasil", "Nacional", "E-commerce")]
SEGMENTOS = ["Varejo", "Varejo", "Varejo", "Corporativo", "Premium"]


def main() -> None:
    (ROOT / "data").mkdir(exist_ok=True)
    DB.unlink(missing_ok=True)
    con = sqlite3.connect(DB)
    con.executescript((ROOT / "sql" / "01_schema.sql").read_text())

    clientes = []
    for i in range(1, 201):
        cidade, uf, _ = random.choice(CIDADES)
        clientes.append((i, f"{random.choice(PRIMEIROS)} {random.choice(SOBRENOMES)} {i:03d}",
                         random.choice(SEGMENTOS), cidade, uf))
    produtos, i = [], 1
    for cat, itens in PRODUTOS.items():
        for nome, custo, preco in itens:
            produtos.append((i, nome, cat, custo, preco)); i += 1
    lojas = [(i, n, r, c) for i, (n, r, c) in enumerate(LOJAS, 1)]
    # Metas anuais ficam em uma dimensão própria, evitando valores fixos no DAX.
    metas = [(2023, 1_050_000.0), (2024, 1_250_000.0), (2025, 1_400_000.0)]

    con.executemany("INSERT INTO dim_cliente VALUES (?,?,?,?,?)", clientes)
    con.executemany("INSERT INTO dim_produto VALUES (?,?,?,?,?)", produtos)
    con.executemany("INSERT INTO dim_loja VALUES (?,?,?,?)", lojas)
    con.executemany("INSERT INTO dim_meta VALUES (?,?)", metas)

    vendas, d0, d1 = [], date(2023, 1, 1), date(2025, 12, 31)
    dias = (d1 - d0).days
    for vid in range(1, 12001):
        d = d0 + timedelta(days=random.randint(0, dias))
        # sazonalidade: peso maior em nov/dez e crescimento anual
        if d.month in (11, 12) or random.random() < 0.55 + 0.1 * (d.year - 2023):
            pass
        else:
            continue
        prod = random.choice(produtos)
        loja = random.choice(lojas)
        qtd = random.choices([1, 2, 3, 4], weights=[60, 25, 10, 5])[0]
        desc = random.choice([0, 0, 0, 0.05, 0.10, 0.15])
        bruto = round(qtd * prod[4], 2)
        vendas.append((len(vendas) + 1, d.isoformat(), random.choice(clientes)[0], prod[0],
                       loja[0], qtd, desc, bruto, round(bruto * (1 - desc), 2)))
    con.executemany("INSERT INTO fato_vendas VALUES (?,?,?,?,?,?,?,?,?)", vendas)
    con.executescript((ROOT / "sql" / "02_views.sql").read_text())
    con.commit()

    for tabela in ["dim_cliente", "dim_produto", "dim_loja", "dim_meta", "fato_vendas", "vw_vendas"]:
        cur = con.execute(f"SELECT * FROM {tabela}")
        with open(ROOT / "data" / f"{tabela}.csv", "w", newline="", encoding="utf-8") as f:
            w = csv.writer(f); w.writerow([c[0] for c in cur.description]); w.writerows(cur)
    print(f"OK: {len(vendas)} vendas, {len(clientes)} clientes, {len(produtos)} produtos -> {DB}")
    con.close()


if __name__ == "__main__":
    main()
