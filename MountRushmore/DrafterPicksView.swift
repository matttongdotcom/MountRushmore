import SwiftUI

// MARK: - ViewState

struct DrafterPicksViewState: Hashable {
    let drafterName: String
    let picks: [String]
    let isCurrentTurn: Bool
}

// MARK: - View

struct DrafterPicksView: View {
    let viewState: DrafterPicksViewState

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
                .padding(.bottom)

            Text(viewState.drafterName)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 8)

            VStack(alignment: .leading, spacing: 8) {
                let displayPicks = (viewState.picks + Array(repeating: "", count: 4)).prefix(4)
                ForEach(Array(displayPicks.enumerated()), id: \.offset) { _, pick in
                    Text(pick.isEmpty ? " " : pick)
                }
            }
        }
        .padding()
        .background(viewState.isCurrentTurn ? Color.blue : Color.gray)
        .cornerRadius(10)
    }
}

// MARK: - Preview

#if DEBUG
extension DrafterPicksViewState {
    static let sample = DrafterPicksViewState(
        drafterName: "John Doe",
        picks: ["First Pick", "Second Pick", "Third Pick", "Fourth Pick"],
        isCurrentTurn: true
    )
}

#Preview {
    NavigationView {
        DrafterPicksView(viewState: .sample)
    }
}
#endif 
