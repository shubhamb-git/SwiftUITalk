//
//  ChatServiceTests.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import XCTest
@testable import SwiftChatKit

final class ChatServiceTests: XCTestCase {
    var service: ChatService!
    var firestoreMock: MockFirestoreChatService!
    var localMock: MockChatMessageDataStore!

    override func setUp() {
        super.setUp()
        firestoreMock = MockFirestoreChatService()
        localMock = MockChatMessageDataStore()
        service = ChatService(firestore: firestoreMock, local: localMock)
    }

    func testSendMessage_savesLocallyAndSendsToFirestore() {
        let message = Message(text: "Hello", senderId: "user1", timestamp: Date())
        service.sendMessage(chatId: "chat123", message: message)

        XCTAssertTrue(firestoreMock.sendMessageCalled)
        XCTAssertEqual(localMock.savedMessages.first?.chatId, "chat123")
    }

    func testCreateChatIfNeeded_callsFirestore() {
        service.createChatIfNeeded(chatId: "chat123", participants: ["user1", "user2"])
        XCTAssertTrue(firestoreMock.createChatCalled)
    }

    func testUpdateTypingStatus() {
        service.updateTypingStatus(chatId: "chat123", userId: "user1", isTyping: true)
        XCTAssertEqual(firestoreMock.typingStatusUpdates.first?.isTyping, true)
    }

    func testListenToTypingStatus_triggersCallback() {
        let expectation = expectation(description: "Typing Status")

        service.listenToTypingStatus(chatId: "chat123", currentUserId: "user1") { isTyping in
            XCTAssertTrue(isTyping)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testMarkMessageAsDelivered_updatesFirestoreAndLocal() {
        service.markMessageAsDelivered(chatId: "chat123", messageId: "msg1")

        XCTAssertEqual(firestoreMock.deliveredUpdates.first?.messageId, "msg1")
        XCTAssertEqual(localMock.updatedStatuses.first?.messageId, "msg1")
    }

    func testMarkMessageAsRead_updatesFirestoreAndLocal() {
        service.markMessageAsRead(chatId: "chat123", messageId: "msg1")

        XCTAssertEqual(firestoreMock.readUpdates.first?.messageId, "msg1")
        XCTAssertEqual(localMock.updatedStatuses.first?.messageId, "msg1")
    }
}
