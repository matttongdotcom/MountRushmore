import Foundation

/// Actions that are sent to the Interactor. These represent business logic operations.
enum CreateDomainAction {
    case createDraft(draftName: String, draftTopic: String)
}

/// A struct representing the state of the application's domain.
struct CreateDomainState {
    var draftName: String = ""
    var topic: String = ""
}

/// The Interactor contains the core business logic.
/// It receives actions and produces a new domain state.
struct CreateInteractor {
    func interact(_ action: CreateDomainAction) async -> CreateDomainState {
        // In a real application, this would contain logic like:
        // - Fetching data from a repository.
        // - Saving data.
        // - Performing calculations.
        print("Interactor received action: \(action)")
        return CreateDomainState() // Returning a dummy state for now.
    }
} 
