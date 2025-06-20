import Foundation

struct CreateRepository {
    func createDraft(draftName: String, topic: String) async throws {
        guard let url = URL(string: "http://127.0.0.1:5001/mount-rushmore-cde9b/us-central1/createDraft") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = CreateDraftRequest(draftName: draftName, topic: topic)
        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
} 