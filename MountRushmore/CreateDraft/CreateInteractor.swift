import Foundation

/// Actions that are sent to the Interactor. These represent business logic operations.
enum CreateDomainAction {
    case createDraft(draftName: String, draftTopic: String)
}

/// A struct representing the state of the application's domain.
struct CreateDomainState {
    var draftName: String = ""
    var topic: String = ""
    var creationStatus: CreationStatus = .idle
}

enum CreationStatus {
    case idle
    case success
    case failure(Error)
}

/// The Interactor contains the core business logic.
/// It receives actions and produces a new domain state.
struct CreateInteractor {
    func interact(_ action: CreateDomainAction) async -> CreateDomainState {
        switch action {
        case .createDraft(let draftName, let draftTopic):
            // In a real application, this would contain logic like:
            // - Fetching data from a repository.
            // - Saving data.
            // - Performing calculations.
            print("Interactor received action: \(action)")
            // Simulate a successful creation.
            return CreateDomainState(draftName: draftName, topic: draftTopic, creationStatus: .success)
        }
    }
} 
