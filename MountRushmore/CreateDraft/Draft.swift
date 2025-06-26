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
    let creator: Creator
}

struct Creator: Codable, Hashable {
    let name: String
    let userId: String
}

struct Participant: Decodable, Hashable {
    let userId: String
    let name: String
}
struct Pick: Decodable, Hashable {} 
