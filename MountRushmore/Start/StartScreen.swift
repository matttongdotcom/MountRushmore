import SwiftUI
import FirebaseAuth

enum NavigationRoute: Hashable {
    case createDraft
    case draftDetails(draftId: String)
}

struct StartScreen: View {
    @EnvironmentObject var authState: AuthState
    @State private var path: [NavigationRoute] = []
    @State private var showingLoginScreen = false

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()

                if authState.isLoggedIn {
                    LoggedInView(path: $path)
                } else {
                    LoggedOutView(showingLoginScreen: $showingLoginScreen)
                }

                Spacer()
            }
            .navigationTitle("start.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .createDraft:
                    CreateDraftScreen(
                        viewModel: CreateViewModel(interactor: CreateInteractor(authState: authState)),
                        path: $path
                    )
                case .draftDetails(let draftId):
                    DraftDetailsScreen(draftId: draftId)
                        .environmentObject(authState)
                }
            }
            .sheet(isPresented: $showingLoginScreen) {
                FirebaseLoginView()
                    .environmentObject(authState) // Pass the authState to the sheet
            }
            // This is a key part: when the auth state changes to logged in,
            // and the sheet is showing, we dismiss it.
            .onChange(of: authState.isLoggedIn) { _, newValue in
                if newValue {
                    showingLoginScreen = false
                }
            }
        }
    }
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen()
            .environmentObject(AuthState()) // For previewing purposes
    }
}
