import Foundation
import SwiftUI
import Combine

// MARK: - View Model

class DraftDetailsViewModel: ObservableObject {
    private var interactor: DraftDetailsInteractor
    private let reducer = DraftDetailsViewStateReducer.self
    @Published private(set) var state: DraftDetailsViewState

    private let viewEventSubject = PassthroughSubject<DraftDetailsViewEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(interactor: DraftDetailsInteractor = DraftDetailsInteractor()) {
        self.interactor = interactor
        self.state = reducer.reduce(domainState: DraftDetailsDomainState(isLoading: true)) // Initial state
        
        viewEventSubject
            .sink { [weak self] event in
                self?.processEvent(event)
            }
            .store(in: &cancellables)
    }

    /// Triggers a view event.
    func send(_ event: DraftDetailsViewEvent) {
        viewEventSubject.send(event)
    }
    
    private func processEvent(_ event: DraftDetailsViewEvent) {
        Task {
            let action = eventToAction(event: event)
            let domainState = await interactor.interact(action)
            await MainActor.run {
                self.state = self.reducer.reduce(domainState: domainState)
            }
        }
    }
    
    private func eventToAction(event: DraftDetailsViewEvent) -> DraftDetailsDomainAction {
        switch event {
        case .fetchDraftDetails:
            return .fetchDraftDetails
        }
    }
}

// MARK: - View-specific models

enum DraftDetailsViewEvent {
    case fetchDraftDetails
}

struct DraftDetailsViewState {
    var draftName: String = ""
    var topic: String = ""
    var link: String = ""
    var participants: [String] = []
    var ctaText: String = ""
    var isLoading: Bool = true
} 