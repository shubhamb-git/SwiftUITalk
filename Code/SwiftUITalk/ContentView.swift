//
//  ContentView.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 19/04/25.
//

import SwiftUI
import SwiftChatKit

struct ContentView: View {
    @EnvironmentObject var session: UserSessionManager

    var body: some View {
        Group {
            if session.isLoggedIn {
                ChatTabView()
                    .onAppear {
                        SwiftChat.shared.configure(uid: session.userId)
                    }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSessionManager.shared)
}
