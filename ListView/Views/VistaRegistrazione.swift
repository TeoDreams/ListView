import SwiftUI

struct VistaRegistrazione: View {
    @Binding var utenti: [Utente]
    @Binding var mostraVista: Bool
    let gestoreDati: GestoreDati

    @State private var nomeUtente: String = ""
    @State private var password: String = ""
    @State private var mostraErrore: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Crea le tue credenziali")) {
                    HStack {
                         Image(systemName: "person.badge.plus.fill")
                            .foregroundColor(.gray)
                        TextField("Nome utente", text: $nomeUtente)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    HStack {
                        Image(systemName: "lock.rectangle.stack.fill")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                    }
                }
                .listRowBackground(Color(.systemGray6))

                Section {
                    Button(action: {
                        let nuovoUtente = Utente(nomeUtente: nomeUtente, password: password)
                        if gestoreDati.registra(utente: nuovoUtente, in: &utenti) {
                            mostraVista = false
                        } else {
                            mostraErrore = true
                        }
                    }) {
                        Text("Registrati")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .tint(.accentColor)
                    .disabled(nomeUtente.isEmpty || password.isEmpty)
                }
            }
            .navigationTitle("Nuovo Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") { mostraVista = false }
                        .tint(.accentColor)
                }
            }
            .alert("Errore Registrazione", isPresented: $mostraErrore) {
                Button("OK") {}
            } message: {
                Text("Questo nome utente è già in uso")
            }
        }
    }
}
