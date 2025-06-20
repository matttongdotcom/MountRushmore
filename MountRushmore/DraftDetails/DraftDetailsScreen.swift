import SwiftUI

struct DraftDetailsScreen: View {
    let draftId: String
    
    var body: some View {
        DraftDetailsView(draftId: draftId)
    }
} 