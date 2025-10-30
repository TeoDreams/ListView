import Foundation

class GestoreDati {

    private let fileUtenti = "utenti.json"
    private let fileListe = "liste.json"

    func registra(utente: Utente, in listaUtenti: inout [Utente]) -> Bool {
        if listaUtenti.contains(where: { $0.nomeUtente == utente.nomeUtente }) {
            return false
        }
        listaUtenti.append(utente)
        salvaGenerico(listaUtenti, nelFile: fileUtenti)
        return true
    }

    func accedi(nomeUtente: String, password: String, da listaUtenti: [Utente]) -> Utente? {
        return listaUtenti.first { $0.nomeUtente == nomeUtente && $0.password == password }
    }

    func aggiungiLista(titolo: String, proprietario: String, aTutteLeListe: inout [ListaSpesa]) {
        let titoloPulito = titolo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !titoloPulito.isEmpty else { return }

        let nuovaLista = ListaSpesa(titolo: titoloPulito, proprietarioUsername: proprietario)
        aTutteLeListe.append(nuovaLista)

        salvaTutteLeListe(aTutteLeListe)
    }

    func eliminaListe(listeDaEliminare: [ListaSpesa], daTutteLeListe: inout [ListaSpesa]) {
        daTutteLeListe.removeAll { listaEsistente in
            listeDaEliminare.contains { $0.id == listaEsistente.id }
        }
        salvaTutteLeListe(daTutteLeListe)
    }

    private func percorsoFile(_ nomeFile: String) -> URL {
        let percorsi = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return percorsi[0].appendingPathComponent(nomeFile)
    }

    func salvaTutteLeListe(_ tutteLeListe: [ListaSpesa]) {
        salvaGenerico(tutteLeListe, nelFile: fileListe)
    }

    func caricaTutteLeListe() -> [ListaSpesa] {
        return caricaGenerico([ListaSpesa].self, dalFile: fileListe) ?? []
    }

    func caricaUtenti() -> [Utente] {
        return caricaGenerico([Utente].self, dalFile: fileUtenti) ?? []
    }

    private func salvaGenerico<T: Codable>(_ dati: T, nelFile nomeFile: String) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let datiCodificati = try encoder.encode(dati)
            try datiCodificati.write(to: percorsoFile(nomeFile), options: .atomic)
        } catch {
            print("Errore nel salvataggio del file \(nomeFile): \(error)")
        }
    }

    private func caricaGenerico<T: Codable>(_ tipo: T.Type, dalFile nomeFile: String) -> T? {
        let percorso = percorsoFile(nomeFile)
        guard FileManager.default.fileExists(atPath: percorso.path) else {
            print("File non trovato: \(nomeFile)")
            return nil
        }
        do {
            let dati = try Data(contentsOf: percorso)
            let datiDecodificati = try JSONDecoder().decode(T.self, from: dati)
            return datiDecodificati
        } catch {
            print("Errore nel caricamento del file \(nomeFile): \(error)")
            return nil
        }
    }
}
