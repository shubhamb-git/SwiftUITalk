//
//  ChatListViewModelTests.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 24/04/25.
//

import XCTest
@testable import SwiftUITalk
@testable import SwiftChatKit

@MainActor
final class ChatListViewModelTests: XCTestCase {

    @MainActor
    func testLoadUsers_successfulFetch() async throws {
        // Arrange
        let mockAuth = MockAuthService()
        mockAuth.userId = "123"

        let mockCoordinator = MockUserCoordinator()
        mockCoordinator.shouldReturn = [
            ChatUser(id: "1", name: "A", email: "a@example.com"),
            ChatUser(id: "2", name: "B", email: "b@example.com")
        ]

        let viewModel = ChatListViewModel(authService: mockAuth, userCoordinator: mockCoordinator)

        // Act
        let expectation = XCTestExpectation(description: "Users loaded")
        viewModel.loadUsers()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)

        // Assert
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(mockCoordinator.fetchCalledWith, "123")
    }


    func testLoadUsers_noCurrentUser_doesNotFetch() {
        // Arrange
        let mockAuth = MockAuthService()
        mockAuth.userId = nil

        let mockCoordinator = MockUserCoordinator()

        let viewModel = ChatListViewModel(authService: mockAuth, userCoordinator: mockCoordinator)

        // Act
        viewModel.loadUsers()

        // Assert
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(mockCoordinator.fetchCalledWith)
    }
}
