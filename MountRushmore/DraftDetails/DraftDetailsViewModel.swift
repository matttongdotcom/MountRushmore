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
        
        setupPipeline()
    }

    /// Triggers a view event.
    func send(_ event: DraftDetailsViewEvent) {
        viewEventSubject.send(event)
    }
    
    private func setupPipeline() {
        // This is the main reactive pipeline.
        // It connects the stream of view events to the interactor and back to the view state.
        let domainActionStream = viewEventSubject.map(eventToAction)
        
        let domainStateStream = interactor.interactV2(
            upstream: domainActionStream
        )

        domainStateStream
            .map { domainState in
                // For each new domain state from the interactor, we reduce it to a view state.
                return self.reducer.reduce(domainState: domainState)
            }
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread.
            .assign(to: &$state)
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