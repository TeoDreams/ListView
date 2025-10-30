import Foundation

struct ArticoloSpesa: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var nome: String
    var quantita: Int = 0
    var descrizione: String?
    var acquistato: Bool = false
}
