import SwiftUI

struct ContentView: View {
    @Binding var tutteLeListe: [ListaSpesa]
    @Binding var utenteCorrente: Utente?
    let gestoreDati: GestoreDati

    var body: some View {
        if let utente = utenteCorrente {
            NavigationStack {
                VistaListe(tutteLeListe: $tutteLeListe, utente: utente, gestoreDati: gestoreDati)
                    .navigationTitle("Le mie Liste")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Esci") {
                                utenteCorrente = nil
                            }
                        }
                    }
            }
        } else {
            Text("Errore: Utente non trovato")
        }
    }
}
