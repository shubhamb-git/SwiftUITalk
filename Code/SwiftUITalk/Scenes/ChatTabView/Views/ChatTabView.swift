//
//  ChatTabView.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import SwiftUI

struct ChatTabView: View {
    var body: some View {
        TabView {
            ChatListView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("Chats")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}
