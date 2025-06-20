//
//  CreateDraftScreen.swift
//  MountRushmore
//
//  Created by Matthew Tong on 6/9/25.
//

import SwiftUI

struct CreateDraftScreen: View {
    
    @ObservedObject var viewModel: CreateViewModel
    @Binding var path: [NavigationRoute]
    
    var body: some View {
        CreateView(
            submitDraftInfo: { name, topic in
                viewModel.send(.createButtonTapped(draftName: name, draftTopic: topic))
            }
        )
        .navigationTitle("createDraft.navigationTitle")
        .onReceive(viewModel.$state) { state in
            print("onReceive: \(state)")
            if case .success(let draft) = state.creationStatus {
                path.append(.draftDetails(draftId: draft.id))
            }
        }
    }
}
