import SwiftUI

struct LoggedOutView: View {
    @Binding var showingLoginScreen: Bool

    var body: some View {
        VStack {
            Text("Welcome to Mount Rushmore")
                .font(.title)

            Text("Please sign in to continue")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)

            Button(action: {
                showingLoginScreen = true
            }) {
                Text("Login / Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }
    }
}

struct LoggedOutView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedOutView(showingLoginScreen: .constant(false))
    }
} 