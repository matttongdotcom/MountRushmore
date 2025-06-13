import SwiftUI
import FirebaseAuth

enum NavigationRoute: Hashable {
    case createDraft
    case draftDetails
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
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .createDraft:
                    // Ensure you pass any required dependencies to your next screens
                    CreateDraftScreen(viewModel: CreateViewModel(), path: $path)
                case .draftDetails:
                    DraftDetailsScreen()
                }
            }
            .sheet(isPresented: $showingLoginScreen) {
                FirebaseLoginView()
                    .environmentObject(authState) // Pass the authState to the sheet
            }
            // This is a key part: when the auth state changes to logged in,
            // and the sheet is showing, we dismiss it.
            .onChange(of: authState.isLoggedIn) { isLoggedIn in
                if isLoggedIn {
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
