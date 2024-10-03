//
//  ChatService.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 01/10/24.
//

import Foundation
import CoreData

class ChatService {
    private let context = PersistenceController.shared.context
  
    func fetchConversations() -> [Conversation] {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching conversations: \(error)")
            return []
        }
    }

    func sendMessage(to user: User, content: String) {
        let message = Message(context: context)
        message.id = UUID()
        message.content = content
        message.timeStamp = Date()
        message.senderId = user.id
        message.isRead = false
        saveMessage(message)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.receiveMockResponse(from: user)
        }
    }

    private func receiveMockResponse(from user: User) {
        let message = Message(context: context)
        message.id = UUID()
        message.content = "Reply from \(user.name)"
        message.timeStamp = Date()
        message.senderId = user.id
        message.isRead = false
        saveMessage(message)
    }

    private func saveMessage(_ message: Message) {
        do {
            try context.save()
        } catch {
            print("Error saving message: \(error)")
        }
    }

    func markMessagesAsRead(for conversation: Conversation) {
        let unreadMessages = fetchUnreadMessages(for: conversation)
        unreadMessages.forEach { $0.isRead = true }
        saveContext()
    }

    private func fetchUnreadMessages(for conversation: Conversation) -> [Message] {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "isRead == NO")
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching unread messages: \(error)")
            return []
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
