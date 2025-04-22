//
//  UserService.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//

import Foundation
import FirebaseFirestore

final class UserService {
    private let db: Firestore
    private let local: ChatDataStore

    init(db: Firestore = FirebaseDB.db, local: ChatDataStore = ChatDataStore.shared) {
        self.db = db
        self.local = local
    }

    func createUserIfNeeded(
        uid: String,
        name: String,
        email: String,
        completion: @escaping (Error?) -> Void
    ) {
        let user = ChatUser(id: uid, name: name, email: email)
        let docRef = db.collection("users").document(uid)

        docRef.getDocument { doc, error in
            if let doc = doc, doc.exists {
                completion(nil) // already exists
            } else {
                do {
                    try docRef.setData(from: user)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func fetchAllUsers(
        excluding uid: String,
        completion: @escaping (Result<[ChatUser], Error>) -> Void
    ) {
        // ✅ First send cached messages immediately
        let cached = local.fetchCachedUsers()
        completion(.success(cached))

        db.collection("users").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                // 🔁 Fallback to cached users on error
                let cached = self.local.fetchCachedUsers().filter { $0.id != uid }
                return completion(.success(cached))
            }

            let users = documents.compactMap { try? $0.data(as: ChatUser.self) }
            let filteredUsers = users.filter { $0.id != uid }

            // ✅ Save to cache
            self.local.saveUsers(filteredUsers)

            completion(.success(filteredUsers))
        }
    }
}
