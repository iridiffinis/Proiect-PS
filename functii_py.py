#1
import pandas as pd
df_produse = pd.read_csv("produse.csv")
suma_categorii = df_produse.groupby("Categorie")["Suma totala"].sum().sort_values(ascending=False)
print(suma_categorii)
lista_categorii = suma_categorii.head(5).index.tolist()
lista_categorii.sort()
print(lista_categorii)

print("________________________________________\n")

#2
df_comenzi = pd.read_json("comenzi.json")

def valoare_totala_comenzi(comenzi):
    total_comenzi={}
    for i, rand in comenzi.iterrows():
        cod_camanda = rand["Cod_Comanda"]
        produse = rand["Produse"]
        val_tot = sum(produs["Valoare"] for produs in produse)
        total_comenzi[cod_camanda] = val_tot
    return total_comenzi

rezultat = valoare_totala_comenzi(df_comenzi)

for cod, val in rezultat.items():
    print("Cod comanda:",cod)
    print("Valoare totala: ",val)

print("________________________________________\n")

#3
df_vanzari = pd.read_csv("vanzari.csv")

df_merged=pd.merge(df_vanzari, df_produse, on="Cod Produs")
df_merged["Valoare TVA"] = df_merged["Cantitate Comandata"] * df_merged["TVA (19%)"]
total_tva = df_merged.groupby("Categorie")["Valoare TVA"].sum()
print(total_tva)

print("________________________________________\n")

#4
df_grouped = df_merged.groupby(["Furnizor", "Categorie"])
df_grouped_agg = df_grouped.agg({
    "Valoare":"mean",
    "Cantitate Comandata": sum
})

df_grouped_agg = df_grouped_agg.reset_index()
print(df_grouped_agg)

print("________________________________________\n")

#5
import matplotlib.pyplot as plt

df_grafic = df_merged.groupby("Categorie")["Valoare"].sum()
print(df_grafic)

plt.figure(figsize=(10,6))
df_grafic.plot(kind="bar",color="blue")
plt.show()


