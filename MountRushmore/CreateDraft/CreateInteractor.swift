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
    case success(Draft)
    case failure(Error)
}

/// The Interactor contains the core business logic.
/// It receives actions and produces a new domain state.
struct CreateInteractor {
    let repository: CreateRepository
    let authState: AuthState

    init(
        repository: CreateRepository = CreateRepository(),
        authState: AuthState = AuthState()
    ) {
        self.repository = repository
        self.authState = authState
    }

    func interact(_ action: CreateDomainAction) async -> CreateDomainState {
        switch action {
        case .createDraft(let draftName, let draftTopic):
            
            guard let userId = authState.user?.uid else {
                return CreateDomainState(creationStatus: .failure(CreateError.userNotLoggedIn))
            }
            
            let creator = Creator(
                name: authState.user?.email ?? "No email", // TODO: use authState.user?.displayName when change is made
                userId: userId
            )
            
            do {
                let draft = try await repository.createDraft(
                    draftName: draftName,
                    topic: draftTopic,
                    creator: creator
                )
                return CreateDomainState(draftName: draftName, topic: draftTopic, creationStatus: .success(draft))
            } catch {
                return CreateDomainState(draftName: draftName, topic: draftTopic, creationStatus: .failure(error))
            }
        }
    }
}

enum CreateError: Error {
    case userNotLoggedIn
} 
