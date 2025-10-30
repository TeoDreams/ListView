# Listify 

Questo è un progetto didattico sviluppato per un corso iOS, focalizzato sull'apprendimento dei fondamenti di SwiftUI.

È un'app semplice per la gestione di liste della spesa che implementa funzionalità di base come l'autenticazione degli utenti, la creazione di liste e la gestione di articoli, il tutto salvando i dati localmente in file JSON.

![Listify screenshot](Screenshot\ListView-screenshot.png)

## Caratteristiche Principali

* **Autenticazione Utente:** Sistema completo di login e registrazione.
* **Multi-utente:** Ogni utente vede solo le proprie liste della spesa. 
* **Gestione Liste:**
    * Aggiungi e elimina liste.
    * Visualizza un contatore per gli articoli rimanenti.
    * Modalità "Modifica" per l'eliminazione multipla.
* **Gestione Articoli:**
    * Aggiungi articoli con nome, quantità e descrizione.
    * Modifica i dettagli di un articolo esistente.
    * Segna gli articoli come "acquistati" con un tap.
    * Elimina articoli con uno swipe o tramite la modalità "Modifica".
* **Persistenza Dati:**
    * Tutti i dati (utenti e liste) vengono salvati localmente in file `utenti.json` e `liste.json` nella cartella Documenti dell'app.

## Tecnologie Utilizzate

* **SwiftUI:** Per l'intera interfaccia utente.
* **Gestione dello Stato:** Utilizzo di `@State` e `@Binding` per gestire il flusso dei dati tra le viste.
* **Componenti UI:** `NavigationStack`, `List`, `Form`, `Button`, `TextField`, `SecureField`, `Stepper`, e `sheet`.
* **Gestione Dati:** Codifica e decodifica di oggetti da e verso file JSON.
