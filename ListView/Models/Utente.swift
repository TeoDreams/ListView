import Foundation

struct Utente: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var nomeUtente: String
    var password: String
}
