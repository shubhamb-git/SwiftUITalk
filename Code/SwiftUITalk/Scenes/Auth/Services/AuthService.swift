//
//  AuthService.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import Foundation
import FirebaseAuth
import SwiftChatKit

final class AuthService {
    static let shared = AuthService()

    private init() {}

    func signUp(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                // ✅ Call SwiftTalkKit to register Firestore user
                SwiftChat.shared.registerUser(uid: user.uid, name: name, email: email) { success in
                    if success {
                        completion(.success(user))
                    } else {
                        // Optional: you may want to delete the user from Auth if Firestore fails
                        completion(.failure(NSError(domain: "AuthService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to register user in Firestore"])))
                    }
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    var currentUser: User? {
        return Auth.auth().currentUser
    }
}
