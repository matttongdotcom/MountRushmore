import SwiftUI
import FirebaseAuth

struct LoggedInView: View {
    @EnvironmentObject var authState: AuthState
    @Binding var path: [NavigationRoute]

    var body: some View {
        VStack {
            if let user = authState.user {
                Text("Welcome, \(user.email ?? "User")!")
                    .font(.title)
                    .padding()

                NavigationLink(value: NavigationRoute.createDraft) {
                    Label("Continue to Draft", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                }
                .padding()
                
                Button("Sign Out", action: {
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