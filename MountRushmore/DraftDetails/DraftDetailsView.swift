import SwiftUI

// MARK: - ViewState

struct DraftDetailsViewState: Hashable {
    let draftName: String
    let topic: String
    let link: String
    let participants: [String]
    let ctaText: String
}

// MARK: - View

struct DraftDetailsView: View {
    let viewState: DraftDetailsViewState
    @State private var justCopied: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header: Draft Name and Topic
            DraftHeaderView(
                viewState: DraftHeaderViewState(
                    draftName: viewState.draftName,
                    draftTopic: viewState.topic
                )
            )

            // Sharable Link
            VStack(alignment: .leading) {
                Text("SHARE LINK").font(.subheadline).foregroundColor(.secondary)
                Button(action: copyLink) {
                    HStack {
                        Image(systemName: "link")
                        Text(viewState.link)
                            .underline()
                        Spacer()
                        if justCopied {
                            Text("Copied!")
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
                Text("PARTICIPANTS")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                List(viewState.participants, id: \.self) { participant in
                    Text(participant)
                }
                .listStyle(PlainListStyle())
            }

            Spacer()

            // START Button
            Button(action: {
                // Action for the START button
            }) {
                Text(viewState.ctaText)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Draft Details")
    }

    private func copyLink() {
        UIPasteboard.general.string = viewState.link
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

#if DEBUG
extension DraftDetailsViewState {
    static let sample = DraftDetailsViewState(
        draftName: "Mount Rushmore",
        topic: "Presidents of the USA",
        link: "https://example.com/draft/mount-rushmore",
        participants: ["George Washington", "Thomas Jefferson", "Theodore Roosevelt", "Abraham Lincoln", "Abraham Lincoln", "Abraham Lincoln", "Abraham Lincoln", "Abraham Lincoln", "Abraham Lincoln", "Abraham Lincoln", "Abraham Lincoln", "Abraham Lincoln" ],
        ctaText: "BEGIN DRAFT"
    )
}

#Preview {
    NavigationView {
        DraftDetailsView(viewState: .sample)
    }
}
#endif 
