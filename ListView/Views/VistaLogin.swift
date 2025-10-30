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
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 5)

                    Text("Listify")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                .padding(.top, 40)
                .padding(.bottom, 30)

                VStack(spacing: 15) {
                    Text("Accedi al tuo account")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        TextField("Nome utente", text: $nomeUtente)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
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
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(10)
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
