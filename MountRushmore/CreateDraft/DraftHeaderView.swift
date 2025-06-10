//
//  DraftHeaderView.swift
//  MountRushmore
//
//  Created by Matthew Tong on 6/8/25.
//

import SwiftUI

struct DraftHeaderViewState: Hashable {
    let draftName: String
    let draftTopic: String
}

struct DraftHeaderView: View {
    
    let viewState: DraftHeaderViewState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewState.draftName)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewState.draftTopic)
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DraftHeaderView(
        viewState: DraftHeaderViewState(
            draftName: "Juice Crew 2025",
            draftTopic: "Desserts"
        )
    )
}
