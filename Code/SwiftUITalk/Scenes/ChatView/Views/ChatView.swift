//
//  ChatView.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
//

import SwiftUI
import SwiftChatKit

struct ChatView: View {

    @StateObject private var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool

    init(chatUser: ChatUser) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(chatUser: chatUser))
    }

    var body: some View {
        ZStack {
            // Chat View Background Color
            Color(UIColor.systemGray6) // Light gray background for chat view area
            
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
                    .padding(.horizontal)
                    .background(Color(UIColor.systemGray6)) // Match background of the chat view
                }

                .onAppear {
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

                // Chat Input Area with a different background color
                .safeAreaInset(edge: .bottom) {
                    chatInputView
                        .padding(.top, 4)
                        .background(Color(UIColor.systemBackground)) // Light background for the input area
                }
            }
        }
        .onTapGesture {
            isInputFocused = false // Dismiss keyboard on tap
        }
        .navigationTitle(viewModel.chatUser.name)
        .navigationBarTitleDisplayMode(.inline)
        .tabBarHidden(true)
    }

    private var chatInputView: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextEditor(text: $viewModel.newMessage)
                .focused($isInputFocused)
                .frame(minHeight: 24, maxHeight: 36)
                .padding(2)
                .background(Color(.clear))
                .cornerRadius(8)
                .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                .onChange(of: viewModel.newMessage) { _ in
                    viewModel.userStartedTyping()
                }

            Button(action: {
                viewModel.sendMessage()
                isInputFocused = false
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.green)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            .disabled(viewModel.newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}


//
//#Preview {
//    ChatView(chatUser: .init(name: "Shubham", email: "Shubh@gmail.com"))
//}
