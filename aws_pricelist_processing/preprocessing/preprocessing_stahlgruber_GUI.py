import pandas as pd
import PySimpleGUI as sg

colspecs = [(0, 7), (7, 33), (33, 34), (34, 43), (43, 44), (44, 45), (45, 47), (47, 50), (50, 59), (59, 75),
            (75, 83), (83, 90), (90, 92), (92, 94),
            (94, 96), (96, 136), (136, 149), (149, 175), (175, 215), (215, 222), (222, 231), (231, 234),
            (234, 258), (258, 259),
            (259, 264), (264, 272), (272, 302), (302, 310), (310, 340)]


def file_preprocessing():
    # GUI-Elemente definieren
    layout = [
              [sg.Text("Diese Applikation fügt der Stahlgruber-Datei automatisch die Überschriften hinzu")],
            [sg.Text("Wähle eine Stahlgruber (90110)-Datei aus")],
              [sg.Text("Stahlgruber-Datei"), sg.InputText(key="filename1"), sg.FileBrowse()],
            [sg.Text("Datum für Output-Datei"), sg.InputText(key="datum")],
              [sg.Submit("Ausführen"), sg.Cancel()]
              ]

    window = sg.Window("Preprocessing Stahlgruber Files").Layout(layout).Finalize()
    event, values = window.read()
    window.close()

    # Verknüpfung GUI-Elemente mit Python-Variablen
    filename1 = values["filename1"]
    filename1 = filename1.replace("\\", "/")
    datum = values["datum"]

    # Einlesen der Datei und Defintion der Header
    if filename1 is not None:
        df = pd.read_fwf(filename1, encoding="cp1252",
                         dtype="string",
                         colspecs=colspecs,
                         names=['Artikelnummer', 'Artikelbezeichnung', 'Preiseinheit', 'vk-Preis Brutto',
                                'Kennzeichen Tauschteil (x oder " ")'
                             , 'Feld 1 (interne Prüfnummer)', 'Feld 2 (interne Prüfnummer)', 'Produktgruppe',
                                'ek-Preis Netto', 'Hersteller-Artikelnummer komprimiert', 'Datum gültig ab',
                                'alternative Artikelnummer', 'Zuordnungsgruppe', 'Warengruppe', 'Warenuntergruppe'
                             , 'Untergruppen-Bezeichnung', 'EAN-Nummer', 'Hersteller-Artikelnummer TecDoc',
                                'Marke Artikel (Lieferant)', 'Pfand-Artikelnummer', 'Pfandwert Brutto',
                                'Kennzeichen Altteil (J/N)'
                             , 'Produktbezeichnung (Gebrauchsnummer)', 'Kennzeichen Gefahrgutartikel (J/N)',
                                'Einspeiser ID-Tecdoc', 'Verkaufseinh./Vielfaches', 'Beschreibung Mindestbestellmenge',
                                'Inhaltsmenge', 'Inhaltsbeschreibung'])

        print(df.shape)
        # Definition des Dateinamens
        outputname = f"PL_90110_{datum}_full.csv"

        # Erstellung der Output-Datei
        df.to_csv(outputname, encoding="UTF-8", index=None, sep=",")
        print("Output-Datei wurde erstellt.")

        print("Funktioniert")

    else:
        print("Fehler")


file_preprocessing()
