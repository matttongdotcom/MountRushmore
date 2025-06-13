import Foundation

/// Actions that are sent to the Interactor. These represent business logic operations.
enum DraftDetailsDomainAction {
    case fetchDraftDetails
}

/// A struct representing the state of the application's domain.
struct DraftDetailsDomainState {
    var draftName: String = ""
    var topic: String = ""
    var link: String = ""
    var participants: [String] = []
    var ctaText: String = ""
    var isLoading: Bool = false
    // We can add more properties as needed, e.g., the list of faces.
}

/// The Interactor contains the core business logic.
/// It receives actions and produces a new domain state.
struct DraftDetailsInteractor {
    func interact(_ action: DraftDetailsDomainAction) async -> DraftDetailsDomainState {
        switch action {
        case .fetchDraftDetails:
            // In a real app, you would fetch details from a repository.
            // For now, we'll return a sample state.
            print("Interactor received action: \(action)")
            // Simulate a network request
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            return DraftDetailsDomainState(
                draftName: "My Awesome Rushmore",
                topic: "Greatest NBA Players",
                link: "https://example.com/draft/nba",
                participants: ["LeBron James", "Michael Jordan", "Kareem Abdul-Jabbar", "Magic Johnson"],
                ctaText: "START DRAFT",
                isLoading: false
            )
        }
    }
} 