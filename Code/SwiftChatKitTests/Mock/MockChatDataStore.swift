//
//  MockChatDataStore.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import Foundation
@testable import SwiftChatKit

class MockChatDataStore: ChatUserDataStoreProtocol {
    var cachedUsers: [ChatUser] = []

    func fetchCachedUsers() -> [ChatUser] {
        return cachedUsers
    }

    func saveUsers(_ users: [ChatUser]) {
        cachedUsers = users
    }
}
