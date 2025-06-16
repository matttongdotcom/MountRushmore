import SwiftUI
import FirebaseAuth

struct LoggedOutView: View {
    @EnvironmentObject var authState: AuthState
    @Binding var showingLoginScreen: Bool
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("loggedOut.title")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            if let errorMessage = authState.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: signIn) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }

            Button(action: {
                showingLoginScreen = true
            }) {
                Text("Create Account / More Options")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(15.0)
            }
        }
        .padding()
    }
    
    private func signIn() {
        authState.signIn(withEmail: email, withPassword: password)
    }
}

struct LoggedOutView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedOutView(showingLoginScreen: .constant(false))
            .environmentObject(AuthState())
    }
} 