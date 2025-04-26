//
//  AuthViewModelTests.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 24/04/25.
//

import XCTest
import SwiftChatKit
@testable import SwiftUITalk

final class AuthViewModelTests: XCTestCase {
    
    @MainActor
    func testLoginSuccess() async throws {
        let auth = MockAuthService()
        let session = MockSessionManager()
        let chat = MockChatConfigurator()

        let viewModel = AuthViewModel(authService: auth, sessionManager: session, chatConfigurable: chat)

        viewModel.email = "test@example.com"
        viewModel.password = "password123"

        viewModel.login()

        // Wait for result
        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.authError)
        XCTAssertTrue(session.started)
        XCTAssertEqual(chat.configuredUID, "123")
    }

    @MainActor
    func testLoginFailure() async throws {
        let auth = MockAuthService()
        auth.shouldFail = true

        let session = MockSessionManager()
        let viewModel = AuthViewModel(authService: auth, sessionManager: session)

        viewModel.email = "fail@example.com"
        viewModel.password = "badpass"
        
        viewModel.login()
        
        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.authError)
    }

    @MainActor
    func testLogoutClearsSession() {
        let auth = MockAuthService()
        let session = MockSessionManager()
        let viewModel = AuthViewModel(authService: auth, sessionManager: session)

        viewModel.email = "temp@example.com"
        viewModel.password = "somepass"
        viewModel.isAuthenticated = true

        viewModel.logout()

        XCTAssertTrue(session.cleared)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
    }

    @MainActor
    func testChatIsConfiguredOnLogin() async throws {
        let chatMock = MockChatConfigurator()
        let session = MockSessionManager()
        let auth = MockAuthService()
        
        let vm = AuthViewModel(
            authService: auth,
            sessionManager: session,
            chatConfigurable: chatMock
        )

        vm.email = "mock@user.com"
        vm.password = "abc123"
        vm.login()

        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(chatMock.configuredUID, "123")
    }

}
