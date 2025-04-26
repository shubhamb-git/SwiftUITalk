//
//  UserService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
//

import Foundation
import FirebaseFirestore

final class UserService {
    private let firestore: FirestoreUserServiceProtocol
    private let local: ChatUserDataStoreProtocol

    init(firestore: FirestoreUserServiceProtocol = FirestoreService(),
         local: ChatUserDataStoreProtocol = ChatDataStore.shared) {
        self.firestore = firestore
        self.local = local
    }

    func createUserIfNeeded(
        uid: String,
        name: String,
        email: String,
        completion: @escaping (Error?) -> Void
    ) {
        firestore.getUserDocument(uid: uid) { result in
            switch result {
            case .success:
                // ✅ User already exists
                completion(nil)
            case .failure:
                // ✅ No user found, so create
                let user = ChatUser(id: uid, name: name, email: email)
                self.firestore.createUser(uid: uid, user: user, completion: completion)
            }
        }
    }

    func fetchAllUsers(
        excluding uid: String,
        completion: @escaping (Result<[ChatUser], Error>) -> Void
    ) {
        // ✅ First send cached users immediately
        let cached = local.fetchCachedUsers().filter { $0.id != uid }
        completion(.success(cached))

        firestore.fetchAllUsers { result in
            switch result {
            case .success(let firestoreUsers):
                let filtered = firestoreUsers.filter { $0.id != uid }
                self.local.saveUsers(filtered)
                completion(.success(self.local.fetchCachedUsers().filter { $0.id != uid }))
            case .failure:
                let fallbackCached = self.local.fetchCachedUsers().filter { $0.id != uid }
                completion(.success(fallbackCached))
            }
        }
    }
}
