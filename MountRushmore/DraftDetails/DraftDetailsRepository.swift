import Foundation

struct DraftDetailsRepository {
    private let api: APIRequest

    init(api: APIRequest = APIRequest()) {
        self.api = api
    }

    func getDraftDetails(draftId: String) async throws -> Draft {
        return try await api.makeRequest(
            httpMethod: .GET,
            path: "https://us-central1-mount-rushmore-cde9b.cloudfunctions.net/getDraft/\(draftId)"
        )
    }
} 