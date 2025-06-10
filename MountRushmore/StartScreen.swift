import SwiftUI

struct StartScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: CreateDraftScreen(viewModel: CreateViewModel())) {
                        HStack {
                            Image(systemName: "plus")
                            Text("BEGIN")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    Spacer()
                }
                Spacer()
            }
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    StartScreen()
}
