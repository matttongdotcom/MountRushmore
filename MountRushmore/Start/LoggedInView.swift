import SwiftUI
import FirebaseAuth

struct LoggedInView: View {
    @EnvironmentObject var authState: AuthState
    @Binding var path: [NavigationRoute]

    private var welcomeMessage: String {
        let format = NSLocalizedString("loggedIn.title", comment: "Welcome message shown to a logged in user. Contains a placeholder for their email.")
        return String(format: format, authState.user?.email ?? "User")
    }

    var body: some View {
        VStack {
            if authState.user != nil {
                Text(welcomeMessage)
                    .font(.title)
                    .padding()

                NavigationLink(value: NavigationRoute.createDraft) {
                    Label("loggedIn.continueButton", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                }
                .padding()
                
                Button("loggedIn.signOutButton", action: {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                })
                .buttonStyle(.bordered)
                .tint(.red)
                .padding(.top)
            }
        }
    }
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView(path: .constant([]))
            .environmentObject(AuthState())
    }
} 