import Foundation
import SwiftUI
import Combine

// MARK: - View Model

final class DraftDetailsViewModel: ObservableObject {
    @Published private(set) var state: DraftDetailsViewState
    private let interactor: DraftDetailsInteractor

    private let viewEventSubject = PassthroughSubject<DraftDetailsViewEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(
        initialState: DraftDetailsViewState = .initial,
        interactor: DraftDetailsInteractor
    ) {
        self.state = initialState
        self.interactor = interactor
        
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
        case .fetchDraftDetails(let draftId):
            return .fetchDraftDetails(draftId: draftId)
        }
    }

    // MARK: - Reducer

    func reduce(
        domainState: DraftDetailsDomainState
    ) -> DraftDetailsViewState {
        switch domainState.loadingState {
        case .idle:
            var newState = self.state
            newState.isLoading = false
            return newState
        case .loading:
            var newState = self.state
            newState.isLoading = true
            return newState
        case .loaded(let draft):
            return DraftDetailsViewState(
                draftName: draft.name,
                topic: draft.topic,
                link: "https://mountrushmore.app/draft/\(draft.id)",
                participants: draft.participants.map { $0.name },
                isLoading: false,
                hasJoinedDraft: domainState.hasJoinedDraft
            )
        }
    }
}

// MARK: - View-specific models

enum DraftDetailsViewEvent {
    case fetchDraftDetails(draftId: String)
}

struct DraftDetailsViewState {
    var draftName: String = ""
    var topic: String = ""
    var link: String = ""
    var participants: [String] = []
    var ctaText: String = ""
    var isLoading: Bool = true
    var hasJoinedDraft: Bool = false
    
    static var initial: DraftDetailsViewState {
        DraftDetailsViewState()
    }
}