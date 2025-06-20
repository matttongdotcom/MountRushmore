import Foundation

struct Draft: Decodable, Identifiable {
    var id: String { draftId }

    let name: String
    let topic: String
    let currentTurn: String
    let isActive: Bool
    let participants: [Participant]
    let picks: [Pick]
    let draftId: String
}

struct Participant: Decodable, Hashable {}
struct Pick: Decodable, Hashable {} 