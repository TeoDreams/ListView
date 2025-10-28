import SwiftUI

struct VistaModificaArticolo: View {
    @Binding var articolo: ArticoloSpesa
    @Binding var tutteLeListe: [ListaSpesa]
    let gestoreDati: GestoreDati
    @Binding var mostraVista: Bool

    @State private var nome: String
    @State private var quantita: Int
    @State private var descrizione: String

    init(articolo: Binding<ArticoloSpesa>, tutteLeListe: Binding<[ListaSpesa]>, gestoreDati: GestoreDati, mostraVista: Binding<Bool>) {
        _articolo = articolo
        _tutteLeListe = tutteLeListe
        self.gestoreDati = gestoreDati
        _mostraVista = mostraVista

        _nome = State(initialValue: articolo.wrappedValue.nome)
        _quantita = State(initialValue: articolo.wrappedValue.quantita)
        _descrizione = State(initialValue: articolo.wrappedValue.descrizione ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Modifica Articolo") {
                    TextField("Nome articolo", text: $nome)
                        .padding(.vertical, 5)
                    Stepper("Quantità: \(quantita)", value: $quantita, in: 1...100)
                        .padding(.vertical, 5)
                    TextField("Descrizione", text: $descrizione)
                        .padding(.vertical, 5)
                }
                 .listRowBackground(Color(.systemGray6))
            }
            .navigationTitle("Modifica Articolo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") {
                        mostraVista = false
                    }
                    .tint(.accentColor)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva") {
                        articolo.nome = nome.trimmingCharacters(in: .whitespaces)
                        articolo.quantita = quantita
                        let descPulita = descrizione.trimmingCharacters(in: .whitespaces)
                        articolo.descrizione = descPulita.isEmpty ? nil : descPulita

                        gestoreDati.salvaTutteLeListe(tutteLeListe)

                        mostraVista = false
                    }
                    .disabled(nome.trimmingCharacters(in: .whitespaces).isEmpty)
                    .tint(.accentColor)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
