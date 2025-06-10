//
//  CreateDraftScreen.swift
//  MountRushmore
//
//  Created by Matthew Tong on 6/9/25.
//

import SwiftUI

struct CreateDraftScreen: View {
    
    @ObservedObject var viewModel: CreateViewModel
    
    var body: some View {
        CreateView(
            submitDraftInfo: { name, topic in
                viewModel.sendViewEventInTask(event: CreateViewEvent.createButtonTapped(draftName: name, draftTopic: topic))
            }
        ).navigationTitle("New Draft")
    }
}
