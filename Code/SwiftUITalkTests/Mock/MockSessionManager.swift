//
//  MockSessionManager.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 24/04/25.
//

@testable import SwiftUITalk

class MockSessionManager: UserSessionManagable {
    var started = false
    var cleared = false

    func startSession(userId: String) {
        started = true
    }

    func clearSession() {
        cleared = true
    }
}
