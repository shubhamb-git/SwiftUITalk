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
                            HStack {
                                if message.senderId == AuthService.shared.currentUser?.uid {
                                    Spacer()
                                }

                                VStack(alignment: message.senderId == AuthService.shared.currentUser?.uid ? .trailing : .leading, spacing: 4) {
                                    Text(message.text)
                                        .padding()
                                        .background(
                                            message.senderId == AuthService.shared.currentUser?.uid
                                                ? Color.blue
                                                : Color.gray.opacity(0.2)
                                        )
                                        .foregroundColor(message.senderId == AuthService.shared.currentUser?.uid ? .white : .black)
                                        .cornerRadius(10)

                                    HStack(spacing: 6) {
                                        Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                                            .font(.caption2)
                                            .foregroundColor(.gray)

                                        if message.senderId == AuthService.shared.currentUser?.uid {
                                            Text(message.isDelivered ? "✓✓" : "✓")
                                                .font(.caption2)
                                                .foregroundColor(message.isRead ? .blue : .gray)
                                        }
                                    }
                                }
                                .onAppear {
                                    viewModel.markMessageAsReadIfNeeded(message: message)
                                }

                                if message.senderId != AuthService.shared.currentUser?.uid {
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .id(message.id)
                        }

                        // ✅ Typing indicator styled as a message bubble
                        if viewModel.isUserTyping {
                            HStack {
                                Text("Typing...")
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.gray)
                                    .cornerRadius(10)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 4) // ✅ Better spacing below last message
                            .transition(.opacity)
                        }

                        // ✅ Invisible scroll anchor
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

#Preview {
    ChatView(chatUser: .init(name: "Shubham", email: "Shubh@gmail.com"))
}
