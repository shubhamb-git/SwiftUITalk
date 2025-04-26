//
//  MockSessionManager.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 24/04/25.
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
