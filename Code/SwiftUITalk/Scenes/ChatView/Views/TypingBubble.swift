//
//  TypingBubble.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//
import SwiftUI

struct TypingBubble: View {
    var body: some View {
        HStack {
            Text("Typing...")
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.gray)
                .cornerRadius(10)
            Spacer()
        }
        .padding(.horizontal)
    }
}
