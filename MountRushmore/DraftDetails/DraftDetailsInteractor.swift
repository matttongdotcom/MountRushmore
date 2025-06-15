import Foundation
import Combine

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
    
    
    /// This is the main Combine-based interaction point for the interactor.
    /// It transforms a stream of actions into a stream of states.
    ///
    /// - Parameter upstream: A publisher that emits domain actions. It is expected not to fail.
    /// - Returns: A publisher that emits domain states, updated according to the actions. This stream will not fail.
    func interactV2(
        upstream: some Publisher<DraftDetailsDomainAction, Never>
    ) -> some Publisher<DraftDetailsDomainState, Never> {
        return upstream
            .flatMap { action -> Future<DraftDetailsDomainState, Never> in
                // For each action, we perform the async business logic and
                // wrap the result in a `Future` publisher. `flatMap` then
                // merges the results from all the futures into a single
                // stream of states.
                return Future { promise in
                    Task {
                        let newState = await self.performAction(action)
                        promise(.success(newState))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// The core business logic is encapsulated in this private async function.
    private func performAction(_ action: DraftDetailsDomainAction) async -> DraftDetailsDomainState {
        switch action {
        case .fetchDraftDetails:
            // In a real app, you would fetch details from a repository.
            // For now, we'll return a sample state.
            print("Interactor received action: \(action)")
            // Simulate a network request
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            return DraftDetailsDomainState(
                draftName: "My Awesome Rushmore V2",
                topic: "Greatest NBA Players",
                link: "https://example.com/draft/nba",
                participants: ["LeBron James", "Michael Jordan", "Kareem Abdul-Jabbar", "Magic Johnson"],
                ctaText: "START DRAFT",
                isLoading: false
            )
        }
    }
} 
