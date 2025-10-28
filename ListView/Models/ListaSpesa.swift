import Foundation

struct ListaSpesa: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var titolo: String
    var articoli: [ArticoloSpesa] = []
    var proprietarioUsername: String

    var conteggioRimanenti: Int {
        articoli.filter { !$0.acquistato }.count
    }
}
