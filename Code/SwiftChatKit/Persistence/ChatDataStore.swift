//
//  ChatDataStore.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 21/04/25.
//

import Foundation
import CoreData

final class ChatDataStore {
    static let shared = ChatDataStore()

    private let container: NSPersistentContainer

    private init() {
        let bundle = Bundle(for: ChatDataStore.self)
       
        print("📦 All bundle resources:", bundle.urls(forResourcesWithExtension: "momd", subdirectory: nil) ?? [])

        guard let modelURL = bundle.url(forResource: "ChatModel", withExtension: "momd") else {
            fatalError("❌ Could not find ChatModel.momd in framework bundle")
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("❌ Failed to load NSManagedObjectModel from URL: \(modelURL)")
        }

        container = NSPersistentContainer(name: "ChatModel", managedObjectModel: model)

        container.loadPersistentStores { some, error in
            if let error = error {
                fatalError("❌ Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }


    private var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Save Messages

    func saveMessages(_ messages: [Message], for chatId: String) {
        context.perform {
            for message in messages {
                let fetch: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
                fetch.predicate = NSPredicate(format: "id == %@", message.id ?? "")

                let existing = try? self.context.fetch(fetch).first
                let entity = existing ?? MessageEntity(context: self.context)

                entity.id = message.id
                entity.text = message.text
                entity.timestamp = message.timestamp
                entity.chatId = chatId
                entity.isDelivered = message.isDelivered
                entity.isRead = message.isRead
                entity
                // 🔁 Attach sender via relationship
                let userEntity = self.fetchUser(with: message.senderId) ?? {
                    let newUser = UserEntity(context: self.context)
                    newUser.id = message.senderId
                    return newUser
                }()
                
                entity.sender = userEntity
            }

            do {
                try self.context.save()
            } catch {
                print("❌ Failed to save messages: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUser(with id: String) -> UserEntity? {
          let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
          request.predicate = NSPredicate(format: "id == %@", id)
          request.fetchLimit = 1

          return try? context.fetch(request).first
      }

    
    // MARK: - Save Users

    func saveUsers(_ users: [ChatUser]) {
        context.perform {
            for user in users {
                let fetch: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                fetch.predicate = NSPredicate(format: "id == %@", user.id ?? "")

                let existing = try? self.context.fetch(fetch).first
                let entity = existing ?? UserEntity(context: self.context)

                entity.id = user.id
                entity.name = user.name
                entity.email = user.email
            }

            do {
                try self.context.save()
            } catch {
                print("❌ Failed to save users: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Load Cached Messages

    func fetchCachedMessages(for chatId: String) -> [Message] {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "chatId == %@", chatId)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MessageEntity.timestamp, ascending: true)]

        do {
            let results = try context.fetch(request)
            return results.map { entity in
                Message(
                    id: entity.id,
                    text: entity.text ?? "",
                    senderId: entity.sender?.id ?? "",
                    timestamp: entity.timestamp ?? Date(),
                    isRead: entity.isRead,
                    isDelivered: entity.isDelivered
                )
            }
        } catch {
            print("❌ Failed to fetch cached messages: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Fetch Cached Users

    func fetchCachedUsers() -> [ChatUser] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let results = try context.fetch(request)
            return results.map { entity in
                ChatUser(id: entity.id, name: entity.name ?? "", email: entity.email ?? "")
            }
        } catch {
            print("❌ Failed to fetch cached users: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateMessageStatus(
        chatId: String,
        messageId: String,
        isRead: Bool? = nil,
        isDelivered: Bool? = nil
    ) {
        context.perform {
            let fetch: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %@ AND chatId == %@", messageId, chatId)
            fetch.fetchLimit = 1

            if let entity = try? self.context.fetch(fetch).first {
                if let isRead = isRead {
                    entity.isRead = isRead
                }
                if let isDelivered = isDelivered {
                    entity.isDelivered = isDelivered
                }

                do {
                    try self.context.save()
                } catch {
                    print("❌ Failed to update cached message status: \(error.localizedDescription)")
                }
            }
        }
    }

}
