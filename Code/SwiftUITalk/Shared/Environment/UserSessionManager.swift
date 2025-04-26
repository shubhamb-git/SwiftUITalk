//
//  UserSessionManager.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import Foundation
import Combine

protocol UserSessionManagable {
    func startSession(userId: String)
    func clearSession()
}

final class UserSessionManager: ObservableObject, UserSessionManagable {
    static let shared = UserSessionManager()

    @UserDefault("isUserLoggedIn", defaultValue: false)
    var isLoggedIn: Bool {
        didSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("userId", defaultValue: "")
    var userId: String {
        didSet {
            objectWillChange.send()
        }
    }

    private init() {}

    func startSession(userId: String) {
        self.isLoggedIn = true
        self.userId = userId
    }

    func clearSession() {
        isLoggedIn = false
        self.userId = ""
    }
}
