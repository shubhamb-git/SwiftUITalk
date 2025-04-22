//
//  Message.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//

import Foundation
import FirebaseFirestore

public struct Message: Identifiable, Codable, Equatable {
    @DocumentID public var id: String?
    public let text: String
    public let senderId: String
    public let timestamp: Date
    public var isRead: Bool = false
    public var isDelivered: Bool = false

    public init(id: String? = nil,
                text: String,
                senderId: String,
                timestamp: Date,
                isRead: Bool = false,
                isDelivered: Bool = false) {
        self.id = id
        self.text = text
        self.senderId = senderId
        self.timestamp = timestamp
        self.isRead = isRead
        self.isDelivered = isDelivered

    }

    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.senderId == rhs.senderId &&
        lhs.timestamp == rhs.timestamp &&
        lhs.isRead == rhs.isRead &&
        lhs.isDelivered == rhs.isDelivered
    }
}
