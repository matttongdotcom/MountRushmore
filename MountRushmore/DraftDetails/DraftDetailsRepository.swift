import Foundation

struct DraftDetailsRepository {
    func getDraftDetails(draftId: String) async throws -> Draft {
        guard let url = URL(string: "https://us-central1-mount-rushmore-cde9b.cloudfunctions.net/getDraft/\(draftId)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("HTTP Status Code: \(httpResponse.statusCode)")
        if let dataString = String(data: data, encoding: .utf8) {
            print("Response data: \(dataString)")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Draft.self, from: data)
    }
} 