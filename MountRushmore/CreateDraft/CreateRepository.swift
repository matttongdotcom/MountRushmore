import Foundation

struct CreateDraftRequest: Encodable {
    let name: String
    let topic: String
    let creator: Creator
}

struct CreateRepository {
    
    private let api: APIRequest
    
    init(api: APIRequest = APIRequest()) {
        self.api = api
    }
    
    func createDraft(draftName: String, topic: String, creator: Creator) async throws -> Draft {
        return try await api.makeRequest(
            httpMethod: .POST,
            path: "https://us-central1-mount-rushmore-cde9b.cloudfunctions.net/createDraft",
            body: CreateDraftRequest(name: draftName, topic: topic, creator: creator)
        )
    }
} 
