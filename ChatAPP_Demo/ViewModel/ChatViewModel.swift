//
//  ChatViewModel.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 01/10/24.
//

import Foundation
import SwiftUI
import CoreData

class ChatViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var messages: [Message] = []
    @Published var typedMessage: String = ""
    let context = PersistenceController.shared.context
    var currentUser: User
    private let chatService = ChatService()
    
    init() {
        self.currentUser = User(context: PersistenceController.shared.context)
        currentUser.id = UUID()
        currentUser.name = "Current User"
        currentUser.avatar = "avatar"
        loadConversations()
    }
    
    // Fetch conversations from Core Data
    func loadConversations() {
        conversations = chatService.fetchConversations()
    }
    
    
    // Send a new message
    func sendMessage(conversation: Conversation) {
        //  chatService.sendMessage(to: user, content: content, conversation: conversation)
        let context = PersistenceController.shared.context
        
        let newMessage = Message(context: context)
        newMessage.id = UUID()
        newMessage.content = typedMessage
        newMessage.timeStamp = Date()
        newMessage.isSentByCurrentUser = true
        newMessage.conversation = conversation
        
        do {
            try context.save()
            typedMessage = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.sendAutoReply(conversation: conversation)
            }
        } catch {
            print("Failed to send message: \(error)")
        }
        // After sending a message, refresh the conversation
        loadConversations()
    }
    
    func sendAutoReply(conversation: Conversation) {
        let context = PersistenceController.shared.context
        
        let replyMessage = Message(context: context)
        replyMessage.id = UUID()
        replyMessage.content = "auto Reply"
        replyMessage.timeStamp = Date()
        replyMessage.isSentByCurrentUser = false
        replyMessage.conversation = conversation
        
        do {
            try context.save()
        } catch {
            print("Failed to send auto reply: \(error)")
        }
    }
    
    // Logout user
    func logoutUser() {
        deleteLoggedInUser()
        deleteAllConversations()
        print("User logged out, all conversations deleted")
    }
    
    func deleteAllConversations() {
        for conversation in conversations {
            context.delete(conversation)
        }
        do {
            try context.save()
            print("All conversations deleted")
        } catch {
            print("Error deleting conversations: \(error)")
        }
        loadConversations() // Refresh conversations after deletion
    }
    
    func deleteLoggedInUser() {
        if let user = chatService.getLoggedInUser() { // Use your service to fetch the logged-in user
            context.delete(user)
            do {
                try context.save()  // Save the context after user deletion
                print("Logged-in user deleted")
            } catch {
                print("Error deleting user: \(error)")
            }
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .none // No date style
        formatter.timeStyle = .short // Only short time style
        return formatter.string(from: date)
    }
}

