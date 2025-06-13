import Foundation

class DraftDetailsViewStateReducer {
    /// Maps the domain state to the view state.
    static func reduce(domainState: DraftDetailsDomainState) -> DraftDetailsViewState {
        return DraftDetailsViewState(
            draftName: domainState.draftName,
            topic: domainState.topic,
            link: domainState.link,
            participants: domainState.participants,
            ctaText: domainState.ctaText,
            isLoading: domainState.isLoading
        )
    }
} 