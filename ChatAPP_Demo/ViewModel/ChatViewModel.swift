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
    
    var currentUser: User

    private let chatService = ChatService()

    init() {
        // Initialize with a mock current user
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
    func sendMessage(to user: User, content: String) {
        chatService.sendMessage(to: user, content: content)
        // After sending a message, refresh the conversation
        loadConversations()
    }
}
