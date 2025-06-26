import Foundation
import SwiftUI
import Combine

// MARK: - View Model

class CreateViewModel: ObservableObject {
    // These would typically be injected as dependencies.
    private var interactor: CreateInteractor
    @Published private(set) var state = CreateDomainState()

    private let viewEventSubject = PassthroughSubject<CreateViewEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(interactor: CreateInteractor) {
        self.interactor = interactor
        
        viewEventSubject
            .sink { [weak self] event in
                self?.processEvent(event)
            }
            .store(in: &cancellables)
    }

    /// Triggers a view event.
    func send(_ event: CreateViewEvent) {
        viewEventSubject.send(event)
    }
    
    private func processEvent(_ event: CreateViewEvent) {
        Task {
            // 1. Convert the UI event into a domain action.
            let action = eventToAction(event: event)
            // 2. The interactor processes the action and returns the new domain state.
            let domainState = await interactor.interact(action)
            // 3. Update the view model's state.
            await MainActor.run {
                self.state = domainState
            }
        }
    }
    
    private func eventToAction(event: CreateViewEvent) -> CreateDomainAction {
        switch event {
        case .createButtonTapped(let draftName, let draftTopic):
            return .createDraft(draftName: draftName, draftTopic: draftTopic)
        }
    }
}

enum CreateViewEvent {
    case createButtonTapped(draftName: String, draftTopic: String)
}
