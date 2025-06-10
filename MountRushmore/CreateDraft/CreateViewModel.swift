import Foundation
import SwiftUI

// MARK: - View Model

class CreateViewModel: ObservableObject {
    // These would typically be injected as dependencies.
    private var interactor = CreateInteractor()
        
    func sendViewEvent(event: CreateViewEvent) async {
        // 1. Convert the UI event into a domain action.
        let action = eventToAction(event: event)
        // 2. The interactor processes the action and returns the new domain state.
        let domainState = await interactor.interact(action)
    }
    
    func eventToAction(event: CreateViewEvent) -> CreateDomainAction {
        switch event {
        case .createButtonTapped(let draftName, let draftTopic):
            return .createDraft(draftName: draftName, draftTopic: draftTopic)
        }
    }
}

// MARK: - Task Helper

extension CreateViewModel {
    /// Helper to run the async `sendViewEvent` from a non-async context.
    func sendViewEventInTask(event: CreateViewEvent, priority: TaskPriority = .userInitiated) {
        Task(priority: priority) {
            await sendViewEvent(event: event)
        }
    }
}

enum CreateViewEvent {
    case createButtonTapped(draftName: String, draftTopic: String)
}
