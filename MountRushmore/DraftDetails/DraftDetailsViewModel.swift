import Foundation
import SwiftUI
import Combine

// MARK: - View Model

final class DraftDetailsViewModel: ObservableObject {
    @Published private(set) var state: DraftDetailsViewState
    private let interactor: DraftDetailsInteractor
    let draftId: String

    private let viewEventSubject = PassthroughSubject<DraftDetailsViewEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(
        initialState: DraftDetailsViewState = .initial,
        interactor: DraftDetailsInteractor = DraftDetailsInteractor(),
        draftId: String
    ) {
        self.state = initialState
        self.interactor = interactor
        self.draftId = draftId
        
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
                return self.reduce(domainState: domainState)
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

    // MARK: - Reducer

    static func reduce(
        _ state: DraftDetailsViewState,
        _ action: DraftDetailsDomainAction
    ) -> DraftDetailsViewState {
        switch action {
        case .initial:
            return .initial
        case .loading:
            var newState = state
            newState.isLoading = true
            return newState
        case .loaded(let draftName, let topic, let link, let participants):
            return DraftDetailsViewState(
                isLoading: false,
                draftName: draftName,
                topic: topic,
                link: link,
                participants: participants
            )
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