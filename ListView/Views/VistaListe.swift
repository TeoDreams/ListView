import SwiftUI

struct VistaListe: View {
    @Binding var tutteLeListe: [ListaSpesa]
    let utente: Utente
    let gestoreDati: GestoreDati

    @State private var mostraAggiungi: Bool = false
    @State private var nuovoTitoloLista: String = ""

    var listeFiltrate: [ListaSpesa] {
        tutteLeListe.filter { $0.proprietarioUsername == utente.nomeUtente }
            .sorted { $0.titolo.localizedCaseInsensitiveCompare($1.titolo) == .orderedAscending }
    }

    private func bindingFiltrato(per lista: ListaSpesa) -> Binding<ListaSpesa> {
        guard let index = tutteLeListe.firstIndex(where: { $0.id == lista.id }) else {
            fatalError("Lista non trovata")
        }
        return $tutteLeListe[index]
    }

    var body: some View {
        ZStack {
            if listeFiltrate.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("Nessuna Lista")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Crea la tua prima lista della spesa premendo il tasto '+' in alto")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                }
            } else {
                List {
                    ForEach(listeFiltrate) { lista in
                        NavigationLink {
                            VistaDettaglioLista(lista: bindingFiltrato(per: lista), tutteLeListe: $tutteLeListe, gestoreDati: gestoreDati)
                        } label: {
                            HStack {
                                Text(lista.titolo)
                                Spacer()
                                if lista.conteggioRimanenti > 0 {
                                    Text("\(lista.conteggioRimanenti)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(8)
                                        .background(Color.accentColor.opacity(0.15))
                                        .foregroundColor(.accentColor)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete { indici in
                        let listeDaEliminare = indici.map { listeFiltrate[$0] }
                        gestoreDati.eliminaListe(listeDaEliminare: listeDaEliminare, daTutteLeListe: &tutteLeListe)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Le mie Liste")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { mostraAggiungi = true } label: { Image(systemName: "plus") }
            }
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
        }
        .sheet(isPresented: $mostraAggiungi) {
            NavigationStack {
                Form {
                    TextField("Nome della nuova lista", text: $nuovoTitoloLista)

                }
                .navigationTitle("Nuova Lista")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Annulla") { mostraAggiungi = false }
                            .tint(.accentColor)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Salva") {
                            gestoreDati.aggiungiLista(titolo: nuovoTitoloLista, proprietario: utente.nomeUtente, aTutteLeListe: &tutteLeListe)
                            mostraAggiungi = false
                            nuovoTitoloLista = ""
                        }
                        .disabled(nuovoTitoloLista.isEmpty)
                        .tint(.accentColor)
                    }
                }
            }
        }
    }
}
