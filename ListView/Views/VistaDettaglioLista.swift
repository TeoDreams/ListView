import SwiftUI

struct VistaDettaglioLista: View {
    @Binding var lista: ListaSpesa
    @Binding var tutteLeListe: [ListaSpesa]
    let gestoreDati: GestoreDati

    @State private var nomeNuovoArticolo: String = ""
    @State private var quantitaNuovoArticolo: Int = 1
    @State private var descrizioneNuovoArticolo: String = ""
    @State private var idArticoloDaModificare: UUID?
    @State private var mostraModificaSheet: Bool = false

    private var articoliOrdinati: [ArticoloSpesa] {
        lista.articoli.sorted { a, b in
            if a.acquistato != b.acquistato {
                return !a.acquistato && b.acquistato
            }
            return a.nome.localizedCaseInsensitiveCompare(b.nome) == .orderedAscending
        }
    }

    private func bindingArticolo(per articoloId: UUID) -> Binding<ArticoloSpesa> {
        guard let index = lista.articoli.firstIndex(where: { $0.id == articoloId }) else {
            fatalError("Articolo non trovato")
        }
        return $lista.articoli[index]
    }

    var body: some View {
        Form {
            Section("Aggiungi Nuovo Articolo") {
                TextField("Nome articolo", text: $nomeNuovoArticolo)
                Stepper("Quantità: \(quantitaNuovoArticolo)", value: $quantitaNuovoArticolo, in: 1...100)
                TextField("Descrizione (opzionale)", text: $descrizioneNuovoArticolo)

                Button(action: {
                    aggiungiArticolo()
                    gestoreDati.salvaTutteLeListe(tutteLeListe)
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Aggiungi alla lista")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .tint(.accentColor)
                .disabled(nomeNuovoArticolo.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .listRowBackground(Color(.systemGray6))

            if !lista.articoli.isEmpty {
                Section("Articoli") {
                    ForEach(articoliOrdinati) { articolo in
                        RigaArticolo(articolo: bindingArticolo(per: articolo.id))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                idArticoloDaModificare = articolo.id
                                mostraModificaSheet = true
                            }
                    }
                    .onDelete { indici in
                        eliminaArticoli(agliIndici: indici)
                        gestoreDati.salvaTutteLeListe(tutteLeListe)
                    }
                }
            } else {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: "basket")
                            .foregroundColor(.secondary)
                        Text("Aggiungi il tuo primo articolo!")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(lista.titolo)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $mostraModificaSheet) {
            if let id = idArticoloDaModificare,
               let index = lista.articoli.firstIndex(where: { $0.id == id }) {
                VistaModificaArticolo(
                    articolo: $lista.articoli[index],
                    tutteLeListe: $tutteLeListe,
                    gestoreDati: gestoreDati,
                    mostraVista: $mostraModificaSheet
                )
            }
        }
        .onChange(of: lista.articoli) { _, _ in
             gestoreDati.salvaTutteLeListe(tutteLeListe)
        }
    }

    func aggiungiArticolo() {
        let nomePulito = nomeNuovoArticolo.trimmingCharacters(in: .whitespaces)
        guard !nomePulito.isEmpty else { return }
        let descrizionePulita = descrizioneNuovoArticolo.trimmingCharacters(in: .whitespaces)
        let descrizione = descrizionePulita.isEmpty ? nil : descrizionePulita
        let nuovoArticolo = ArticoloSpesa(nome: nomePulito, quantita: quantitaNuovoArticolo, descrizione: descrizione)
        lista.articoli.append(nuovoArticolo)

        nomeNuovoArticolo = ""
        quantitaNuovoArticolo = 1
        descrizioneNuovoArticolo = ""
    }

    func eliminaArticoli(agliIndici indici: IndexSet) {
        let idDaEliminare = indici.map { articoliOrdinati[$0].id }
        lista.articoli.removeAll { idDaEliminare.contains($0.id) }
    }
}

struct RigaArticolo: View {
    @Binding var articolo: ArticoloSpesa

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Button(action: {
                articolo.acquistato.toggle()
            }) {
                Image(systemName: articolo.acquistato ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(articolo.acquistato ? .green : .accentColor)
                    .font(.title3)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(articolo.nome)
                        .font(.body)
                        .fontWeight(.medium)
                    if articolo.quantita > 1 {
                        Text("x\(articolo.quantita)")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .padding(.leading, -2)
                    }
                }

                if let descrizione = articolo.descrizione, !descrizione.isEmpty {
                    Text(descrizione)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.vertical, 5)
        .opacity(articolo.acquistato ? 0.5 : 1.0)
        .strikethrough(articolo.acquistato, color: .secondary)
    }
}
