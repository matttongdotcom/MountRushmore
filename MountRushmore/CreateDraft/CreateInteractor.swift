import Foundation

struct CreateDraftRequest: Encodable {
    let draftName: String
    let topic: String
}

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
    let repository: CreateRepository

    init(repository: CreateRepository = CreateRepository()) {
        self.repository = repository
    }

    func interact(_ action: CreateDomainAction) async -> CreateDomainState {
        switch action {
        case .createDraft(let draftName, let draftTopic):
            do {
                try await repository.createDraft(draftName: draftName, topic: draftTopic)
                return CreateDomainState(draftName: draftName, topic: draftTopic, creationStatus: .success)
            } catch {
                return CreateDomainState(draftName: draftName, topic: draftTopic, creationStatus: .failure(error))
            }
        }
    }
} 
