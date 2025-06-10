//
//  CreateDraftScreen.swift
//  MountRushmore
//
//  Created by Matthew Tong on 6/9/25.
//

import SwiftUI

struct CreateDraftScreen: View {
    
    @ObservedObject var viewModel: CreateViewModel
    @State private var navigateToNextScreen = false
    
    var body: some View {
        NavigationView {
            CreateView(
                submitDraftInfo: { name, topic in
                    viewModel.send(.createButtonTapped(draftName: name, draftTopic: topic))
                }
            )
            .navigationTitle("New Draft")
        }
        .onReceive(viewModel.$state) { state in
            print("onReceive: \(state)")
            if case .success = state.creationStatus {
                navigateToNextScreen = true
            }
        }
    }
}
