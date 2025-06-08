import SwiftUI

// MARK: - ViewState

struct DraftBoardViewState: Hashable {
    let drafters: [DrafterPicksViewState]
}

// MARK: - View

struct DraftBoardView: View {
    let viewState: DraftBoardViewState
    
    @State private var draftPick: String = ""

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                TextField("Enter draft pick", text: $draftPick)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Text("SUBMIT")
                    Image(systemName: "check")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }.padding()
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewState.drafters, id: \.self) { drafterState in
                        DrafterPicksView(viewState: drafterState)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Draft Board")
    }
}

// MARK: - Preview

#if DEBUG
extension DraftBoardViewState {
    static let sample = DraftBoardViewState(
        drafters: [
            .init(drafterName: "Team A", picks: ["Pick 1A", "Pick 2A", "Pick 3A"], isCurrentTurn: false),
            .init(drafterName: "Team B", picks: ["Pick 1B", "Pick 2B", "Pick 3B"], isCurrentTurn: true),
            .init(drafterName: "Team C", picks: ["Pick 1C", "Pick 2C", "Pick 3C"], isCurrentTurn: false),
            .init(drafterName: "Team D", picks: ["Pick 1D", "Pick 2D", "Pick 3D"], isCurrentTurn: false)
        ]
    )
}

#Preview {
    NavigationView {
        DraftBoardView(viewState: .sample)
    }
}
#endif 
