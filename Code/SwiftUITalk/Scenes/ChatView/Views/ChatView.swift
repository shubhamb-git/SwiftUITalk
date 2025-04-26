//
//  ChatView.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//

import SwiftUI
import SwiftChatKit

struct ChatView: View {
    
    @StateObject private var viewModel: ChatViewModel

    init(chatUser: ChatUser) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(chatUser: chatUser))
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageRow(message: message)
                                .id(message.id)
                        }
                        if viewModel.isUserTyping {
                            TypingBubble()
                                .padding(.top, 4)
                        }

                        Color.clear
                            .frame(height: 1)
                            .id("BottomAnchor")
                    }
                }
                .onAppear {
                    // ✅ Scroll to bottom on first open
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            proxy.scrollTo("BottomAnchor", anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.messages) { _ in
                    withAnimation {
                        proxy.scrollTo("BottomAnchor", anchor: .bottom)
                    }
                }
                .onChange(of: viewModel.isUserTyping) { _ in
                    withAnimation {
                        proxy.scrollTo("BottomAnchor", anchor: .bottom)
                    }
                }
            }

            Divider()

            HStack {
                TextField("Message...", text: $viewModel.newMessage)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .onChange(of: viewModel.newMessage) { _ in
                        viewModel.userStartedTyping()
                    }

                Button("Send") {
                    viewModel.sendMessage()
                }
                .disabled(viewModel.newMessage.trimmingCharacters(in: .whitespaces).isEmpty) // ✅ prevent empty send
                .padding(.horizontal)
            }
            .padding(.bottom, 44)
            .padding(.leading, 20)
        }
        .tabBarHidden(true)
        .edgesIgnoringSafeArea(.bottom) // ✅ Important to collapse space
        .navigationTitle(viewModel.chatUser.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
//
//#Preview {
//    ChatView(chatUser: .init(name: "Shubham", email: "Shubh@gmail.com"))
//}
