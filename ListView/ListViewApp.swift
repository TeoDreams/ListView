import SwiftUI

@main
struct ListViewApp: App {
    @State private var utenti: [Utente]
    @State private var tutteLeListe: [ListaSpesa]
    @State private var utenteCorrente: Utente? = nil

    private let gestoreDati = GestoreDati()

    init() {
        let gestore = GestoreDati()
        _utenti = State(initialValue: gestore.caricaUtenti())
        _tutteLeListe = State(initialValue: gestore.caricaTutteLeListe())
    }

    var body: some Scene {
        WindowGroup {
            if utenteCorrente != nil {
                ContentView(
                    tutteLeListe: $tutteLeListe,
                    utenteCorrente: $utenteCorrente,
                    gestoreDati: gestoreDati
                )
            } else {
                VistaLogin(
                    utenti: $utenti,
                    utenteCorrente: $utenteCorrente,
                    gestoreDati: gestoreDati
                )
            }
        }
    }
}
