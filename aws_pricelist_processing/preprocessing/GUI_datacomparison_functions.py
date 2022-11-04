import PySimpleGUI as sg
import pandas as pd


# Leere Listen
header_list = []

layout = [[sg.Text("Wähle 2 Dateien aus")],
                [sg.Text("Seperator CSV"), sg.InputText(key="separator",size=2)],
              #[sg.Text("Seperator CSV (2.Datei)"), sg.InputText(key="separator2")],
                #[sg.Text("Zeichenkodierung z.B. UTF-8, ANSI, ..."), sg.InputText(key="codierung",size=7)],
                [sg.Text("Gesuchtes Zeichen"), sg.InputText(key="zeichen", size=15)],
                [sg.Text("1.Datei"), sg.InputText(key="filename1"), sg.FileBrowse()],
                [sg.Text("2.Datei"), sg.InputText(key="filename2"), sg.FileBrowse()],
                #[sg.Text("Zeichencodierung"),sg.ButtonMenu("Codierung", menu_def=codierung_auswahl, key="codierung")],
                [sg.Submit("Ausführen"), sg.Cancel()]
            ]

window = sg.Window("Dateiabgleiche").Layout(layout).Finalize()
event, values = window.read()
window.close()


#Verknüpfung GUI-Elemente mit Python-Variablen
filename1, filename2 = values["filename1"],values["filename2"]
filename1 = filename1.replace("\\", "/")
filename2 = filename2.replace("\\", "/")
trennzeichen,symbol = values["separator"],values["zeichen"]
#codierung = values["codierung"]


anzahl = 1

def select_column_row(liste):
    index = 1
    ergebnis = []

    for i in liste:
        if i == True:
            n = ("Spalte "+ str(index))
            ergebnis.append(n)
        index = index+1

    return ergebnis

def column_row(dataframe2):

    spalten = dataframe2.apply(lambda column: column.astype(str).str.contains(symbol).any(), axis=0)
    liste = set(spalten)
    liste = spalten.to_list()
    print("> Spalten mit dem " + str(symbol) + " Zeichen sind: " + str(select_column_row(liste)))


    zeilen = dataframe2.apply(lambda row: row.astype(str).str.contains(symbol).any(), axis=1)
    liste = set(zeilen)
    liste = zeilen.to_list()
    lergebnis = select_column_row(liste)
    lae_erg = len(lergebnis)
    print("> Das Zeichen " + str(symbol) + " wurde in " + str(lae_erg) + " Zeilen gefunden")


def search_null(dataframe2):
    nullliste = dataframe2.columns[dataframe2.isna().any()]
    if nullliste.empty:
        print("Datei hat keine leeren Spalten bzw. Zeilen")
    else:
        print("Prüfung nach leeren Spalten bzw. Zeilen: ")
        null_zeile = pd.isnull(dataframe2).sum()
        null_liste = null_zeile.tolist()
        null_ergebnis = []
        for n in null_liste:
            if n > 0:
                null_ergebnis.append(n)

        nullzeile_sum = 0
        for n in null_ergebnis:
            nullzeile_sum = nullzeile_sum+n
        print("> Datei hat " + str(nullzeile_sum) + " Zeilen mit leeren Werten.")
        print("> Spalten mit leeren Werten sind: " + str(nullliste))

def import_csv(file, anzahl):
    df = pd.read_csv(file, sep=trennzeichen, engine="python", dtype="string", encoding="ANSI", nrows=anzahl)
    header_list = df.columns.to_list()
    print(file)
    print(df.shape)
    return header_list

def import_excel(file, anzahl):
    df = pd.read_excel(file, engine="openpyxl", dtype="string", nrows=anzahl)
    header_list = df.columns.to_list()
    print(file)
    print(df.shape)
    return header_list

def header_compare(header1, header2):
    if header1 != header2:
        print("Die Überschriften sind unterschiedlich")
        header1_col = set(header1)
        header2_col = set(header2)

        difference = header2_col.difference(header1_col)

        structure_index = [header2.index(n) for m, n in zip(header1, header2) if n !=m]
        structure_result = []
        for i in structure_index:
            i = i+1
            structure_result.append(i)
        print("> Anzahl unterschiedlicher Überschriften: " + str(len(difference)))
        print("> unterschiedliche Überschriften: " + str(difference))
        print("> unterschiedlicher Aufbau in den Spalten " + str(structure_result))
    else:
        print("Aufbau und Bezeichnung der Überschriften sind gleich")

def search_symbol(symbol, filename2):
    if symbol != "":
        if filename2.endswith(".csv"):
            dataframe2 = pd.read_csv(filename2, sep=trennzeichen, engine="python", dtype="string", encoding="ANSI")
            print(dataframe2.shape)
        elif filename2.endswith(".xlsx"):
            dataframe2 = pd.read_excel(filename2, engine="openpyxl", dtype="string")
            print(dataframe2.shape)
        else:
            print("Es wurde kein Zeichen definiert")
        print("Suche nach dem Zeichen "+ str(symbol))

        column_row(dataframe2)

        search_null(dataframe2)

def processing():
    if filename1 and filename2 is not None:
        try:
            if filename1.endswith(".csv") and filename2.endswith(".csv"):
                file = filename1
                header1 = import_csv(file, anzahl)
                print(header1)
                file = filename2
                header2 = import_csv(file, anzahl)
                print(header2)
            elif filename1.endswith(".xlsx") and filename2.endswith(".xlsx"):
                file = filename1
                header1 = import_excel(file, anzahl)
                print(header1)
                file = filename2
                header2 = import_excel(file, anzahl)
                print(header2)
            elif filename1.endswith(".csv") and filename2.endswith(".xlsx"):
                file = filename1
                header1 = import_csv(file, anzahl)
                print(header1)
                file = filename2
                header2 = import_excel(file, anzahl)
                print(header2)
            elif filename1.endswith(".xlsx") and filename2.endswith(".csv"):
                file = filename1
                header1 = import_excel(file, anzahl)
                print(header1)
                file = filename2
                header2 = import_csv(file, anzahl)
                print(header2)
            else:
                print("Dateiformat wird nicht unterstützt")
        except:
            print("Fehler")

    header_compare(header1, header2)

    search_symbol(symbol, filename2) 

processing()
