//
//  MountRushmoreApp.swift
//  MountRushmore
//
//  Created by Matthew Tong on 6/4/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MountRushmoreApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authState = AuthState()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(authState)
            }
        }
    }
}

let sample = DraftBoardViewState(
    draftName: "Juice Crew Draft 2025",
    draftTopic: "Best Desserts",
    currentPick: "Matt",
    drafters: [
        .init(drafterName: "Team A", picks: ["Pick 1A", "Pick 2A", "Pick 3A"], isCurrentTurn: false),
        .init(drafterName: "Team B", picks: ["Pick 1B", "Pick 2B", "Pick 3B"], isCurrentTurn: true),
        .init(drafterName: "Team C", picks: ["Pick 1C", "Pick 2C", "Pick 3C"], isCurrentTurn: false),
        .init(drafterName: "Team D", picks: ["Pick 1D", "Pick 2D", "Pick 3D"], isCurrentTurn: false)
    ]
)
