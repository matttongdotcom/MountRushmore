import SwiftUI

// MARK: - View

struct DraftDetailsView: View {
    @ObservedObject var viewModel: DraftDetailsViewModel
    @State private var justCopied: Bool = false
    let draftId: String

    var body: some View {
        VStack {
            if viewModel.state.isLoading {
                ProgressView()
                Spacer()
            } else {
                content
            }
        }
        .onAppear {
            viewModel.send(.fetchDraftDetails(draftId: draftId))
        }
        .padding()
        .navigationTitle("draftDetails.navigationTitle")
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header: Draft Name and Topic
            DraftHeaderView(
                viewState: DraftHeaderViewState(
                    draftName: viewModel.state.draftName,
                    draftTopic: viewModel.state.topic
                )
            )

            // Sharable Link
            VStack(alignment: .leading) {
                Text("draftDetails.shareLinkHeader").font(.subheadline).foregroundColor(.secondary)
                Button(action: copyLink) {
                    HStack {
                        Image(systemName: "link")
                        Text(viewModel.state.link)
                            .underline()
                        Spacer()
                        if justCopied {
                            Text("draftDetails.copiedBanner")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .transition(.opacity)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical)

            // Participants List
            VStack(alignment: .leading) {
                Text("draftDetails.participantsHeader")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                List(viewModel.state.participants, id: \.self) { participant in
                    Text(participant)
                }
                .listStyle(PlainListStyle())
            }

            Spacer()

            // CTA Button
            if viewModel.state.hasJoinedDraft {
                Button(action: {
                    // Action for the START button
                }) {
                    Text("draftDetails.startButton")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Button(action: {
                    // Action for the JOIN button
                }) {
                    Text("draftDetails.joinButton")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }

    private func copyLink() {
        UIPasteboard.general.string = viewModel.state.link
        withAnimation {
            justCopied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                justCopied = false
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        let authState = AuthState()
        let interactor = DraftDetailsInteractor(authState: authState)
        let viewModel = DraftDetailsViewModel(interactor: interactor)
        DraftDetailsView(viewModel: viewModel, draftId: "123")
    }
} 
