//
//  ChatMessageRow.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import SwiftUI
import SwiftChatKit

struct ChatMessageRow: View {
    let message: Message

    var isCurrentUser: Bool {
        message.senderId == AuthService.shared.currentUser?.uid
    }

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }

            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.subheadline)
                    .padding(8)
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .cornerRadius(10)

                HStack(spacing: 6) {
                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.footnote)
                        .foregroundColor(.gray)

                    if isCurrentUser {
                        Text(message.isDelivered ? "✓✓" : "✓")
                            .font(.footnote)
                            .foregroundColor(message.isRead ? .blue : .gray)
                    }
                }
            }

            if !isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
