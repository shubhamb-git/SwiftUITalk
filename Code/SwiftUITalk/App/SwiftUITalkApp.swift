//
//  SwiftUITalkApp.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import SwiftUI
import Firebase

@main
struct SwiftUITalkApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var session = UserSessionManager.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(session)
        }
    }
}
