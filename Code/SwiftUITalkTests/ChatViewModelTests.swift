//
//  ChatViewModelTests.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 24/04/25.
//

import XCTest
@testable import SwiftChatKit
@testable import SwiftUITalk

@MainActor
final class ChatViewModelTests: XCTestCase {

    // ✅ Test 1: Message sending clears input and calls coordinator
    func testSendMessageClearsInput() {
        let chatMock = MockChatCoordinator()
        let user = ChatUser(id: "user123", name: "Test User", email: "test@example.com")
        let viewModel = ChatViewModel(chatUser: user, chatCoordinator: chatMock)

        viewModel.newMessage = "Hello world"
        viewModel.sendMessage()

        XCTAssertEqual(chatMock.lastSentText, "Hello world")
        XCTAssertEqual(viewModel.newMessage, "")
    }

    // ✅ Test 2: Typing status triggers coordinator and resets
    func testTypingStatusTriggersUpdate() async {
        let chatMock = MockChatCoordinator()
        let user = ChatUser(id: "user123", name: "Test User", email: "test@example.com")
        let viewModel = ChatViewModel(chatUser: user, chatCoordinator: chatMock)

        viewModel.newMessage = "Typing..."
        viewModel.userStartedTyping()

        XCTAssertEqual(chatMock.typingUpdates.first, true)

        try? await Task.sleep(nanoseconds: 2_100_000_000)

        XCTAssertTrue(chatMock.typingUpdates.contains(false))
    }

    // ✅ Test 3: Message marked as read once
    func testMessageMarkedAsReadOnce() {
        let chatMock = MockChatCoordinator()
        let user = ChatUser(id: "user123", name: "Test User", email: "test@example.com")
        let viewModel = ChatViewModel(chatUser: user, chatCoordinator: chatMock)

        // Setup: mimic current user UID
        let message = Message(id: "m1", text: "Read me", senderId: "someone_else", timestamp: Date(), isRead: false)

        viewModel.markMessageAsReadIfNeeded(message: message)
        viewModel.markMessageAsReadIfNeeded(message: message) // Call again to test idempotency

        XCTAssertEqual(chatMock.readMessageCalls.count, 1)
        XCTAssertEqual(chatMock.readMessageCalls.first?.messageId, "m1")
    }
}
