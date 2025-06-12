import SwiftUI

enum NavigationRoute: Hashable {
    case createDraft
    case draftDetails
}

struct StartScreen: View {
    @State private var path = [NavigationRoute]()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(value: NavigationRoute.createDraft) {
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
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .createDraft:
                    CreateDraftScreen(viewModel: CreateViewModel(), path: $path)
                case .draftDetails:
                    DraftDetailsScreen()
                }
            }
        }
    }
}

#Preview {
    StartScreen()
}
