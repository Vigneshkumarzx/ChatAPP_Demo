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
    
    func getLoggedInUser() -> User? {
           let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "name == %@", UserDefaults.standard.string(forKey: "loggedInUser") ?? "")
           
           do {
               let users = try context.fetch(fetchRequest)
               return users.first
           } catch {
               print("Error fetching logged-in user: \(error)")
               return nil
           }
       }
    
    private func receiveMockResponse(from user: User) {
        let message = Message(context: context)
        message.id = UUID()
        message.content = "Reply from \(user.name ?? "username")"
        message.timeStamp = Date()
        message.senderId = user.id
        message.isRead = false
        
        do {
            try context.save()
        } catch {
            print("Failed to send auto reply: \(error)")
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
