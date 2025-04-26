//
//  ChatUser.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
//

import Foundation
import FirebaseFirestore

public struct ChatUser: Identifiable, Codable {
    @DocumentID public var id: String?
    public let name: String
    public let email: String
    public var profileImageURL: String?
    public var lastMessageTimestamp: Date?

    public init(id: String? = nil,
                name: String,
                email: String,
                profileImageURL: String? = nil,
                lastMessageTimestamp: Date? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.lastMessageTimestamp = lastMessageTimestamp

    }
}
