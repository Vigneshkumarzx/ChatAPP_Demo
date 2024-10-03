//
//  LoginViewModel.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 03/10/24.
//

import Foundation
import SwiftUI
import CoreData

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var isLoggedIn = false
    @Published var loggedInUser: User?
    @Published var showToast = false
    @Published var toastMessage = ""
    
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    // Function to handle login
    func loginUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", username)
        
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let savedUsername = UserDefaults.standard.string(forKey: "loggedInUser") {
                if let user = users.first, user.name == savedUsername {
                    // User exists, navigate to Home Screen
                    loggedInUser = user
                    showToastMessage("Welcome Back")
                } else {
                    createNewUser()
                }
            } else {
                createNewUser()
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }

    // Function to create new user and save to Core Data
    private func createNewUser() {
        let newUser = User(context: viewContext)
        newUser.id = UUID()
        newUser.name = username
        loggedInUser = newUser
        
        do {
            try viewContext.save()
            addMockConversations(loggedInUser: newUser)
            UserDefaults.standard.set(username, forKey: "loggedInUser")
            showToastMessage("New user created")
        } catch {
            print("Error saving new user: \(error)")
        }
    }

    // Create mock conversations
    private func addMockConversations(loggedInUser: User) {
        let context = PersistenceController.shared.context
        let user2 = User(context: context)
        user2.id = UUID()
        user2.name = "Another User"
        user2.avatar = "avatar_other"
        
        let user3 = User(context: context)
        user3.id = UUID()
        user3.name = "Third User"
        user3.avatar = "avatar_third"
        
        for i in 1...3 {
            let conversation = Conversation(context: context)
            conversation.id = UUID()
            conversation.lastMessage = "Hello from \(loggedInUser.name ?? "Unknown") to conversation \(i)!"
            conversation.participants = [loggedInUser, user2, user3]
            
            do {
                try context.save()
            } catch {
                print("Failed to save conversation: \(error)")
            }
        }
    }

    // Display toast message
    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.showToast = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoggedIn = true
            }
        }
    }
}
