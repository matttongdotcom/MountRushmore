import Foundation
import Combine

/// Actions that are sent to the Interactor. These represent business logic operations.
enum DraftDetailsDomainAction {
    case fetchDraftDetails(draftId: String)
}

/// A struct representing the state of the application's domain.
struct DraftDetailsDomainState {
    var loadingState: LoadingState = .idle
    var hasJoinedDraft: Bool = false

    enum LoadingState {
        case idle
        case loading
        case loaded(draft: Draft)
    }
}

/// The Interactor contains the core business logic.
/// It receives actions and produces a new domain state.
struct DraftDetailsInteractor {
    
    let repository: DraftDetailsRepository
    let authState: AuthState
    
    init(
        repository: DraftDetailsRepository = DraftDetailsRepository(),
        authState: AuthState = AuthState()
    ) {
        self.repository = repository
        self.authState = authState
    }
    
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
        case .fetchDraftDetails(let draftId):
            print("Interactor received action: \(action) with draftId: \(draftId)")
            do {
                let draft = try await repository.getDraftDetails(draftId: draftId)
                let loadedState = DraftDetailsDomainState.LoadingState.loaded(draft: draft)
                guard let userId = authState.user?.uid else {
                    return DraftDetailsDomainState(loadingState: loadedState, hasJoinedDraft: false)
                }
                
                let hasJoined = draft.participants.contains { $0.id == userId }
                
                return DraftDetailsDomainState(loadingState: loadedState, hasJoinedDraft: hasJoined)
            } catch {
                print("Failed to fetch draft details: \(error)")
                return DraftDetailsDomainState(loadingState: .idle)
            }
        }
    }
} 
