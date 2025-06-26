import SwiftUI

struct DraftDetailsScreen: View {
    let draftId: String
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        let interactor = DraftDetailsInteractor(authState: authState)
        let viewModel = DraftDetailsViewModel(interactor: interactor)
        DraftDetailsView(viewModel: viewModel, draftId: draftId)
    }
} 