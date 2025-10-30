import SwiftUI

struct VistaLogin: View {
    @Binding var utenti: [Utente]
    @Binding var utenteCorrente: Utente?
    let gestoreDati: GestoreDati

    @State private var nomeUtente: String = ""
    @State private var password: String = ""
    @State private var mostraErrore: Bool = false
    @State private var mostraRegistrazione: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                VStack {
                    Image(systemName: "list.bullet.clipboard.fill")


                    Text("Listify")

                }


                VStack(spacing: 15) {
                    Text("Accedi al tuo account")


                    HStack {
                        Image(systemName: "person.fill")

                        TextField("Nome utente", text: $nomeUtente)

                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    HStack {
                        Image(systemName: "lock.fill")
                        SecureField("Password", text: $password)
                    }

                }
                .padding(.horizontal)

                VStack(spacing: 15) {
                    Button(action: {
                        if let utente = gestoreDati.accedi(nomeUtente: nomeUtente, password: password, da: utenti) {
                            utenteCorrente = utente
                        } else {
                            mostraErrore = true
                        }
                    }) {
                        Text("Accedi")

                    }
                    .disabled(nomeUtente.isEmpty || password.isEmpty)

                    Button("Non hai un account? Registrati") {
                        mostraRegistrazione = true
                    }
                    .tint(.accentColor)
                }
                .padding(.horizontal)
                .padding(.top, 25)

                Spacer()
            }
            .navigationTitle("Login")
            .navigationBarHidden(true)
            .sheet(isPresented: $mostraRegistrazione) {
                VistaRegistrazione(
                    utenti: $utenti,
                    mostraVista: $mostraRegistrazione,
                    gestoreDati: gestoreDati
                )
            }
            .alert("Errore Accesso", isPresented: $mostraErrore) {
                Button("OK") {}
            } message: {
                Text("Username o password non corretti")
            }
        }
    }
}
