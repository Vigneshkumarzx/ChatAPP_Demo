//
//  LoginView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @State private var username: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isLoggedIn = false
    @State private var loggedInUser: User?
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter your Username")
                    .font(.title)
                    .frame(alignment: .leading)
                Text("Please enter your username to validate you as new or registered user of chat platform")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
                    .padding(.top, 4)
                TextField("Enter username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    loginUser()
                }) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
                if showToast {
                    ToastView(message: toastMessage)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: showToast)
                }
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                if let user = loggedInUser {
                    ConversationListView()
                }
            }
        }
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
                   // addMockConversations(loggedInUser: user)
                    print("User already exists, navigate to Home Screen")
                    showToastMessage("Welcome Back")
                } else {
                    // Create new user
                    let newUser = User(context: viewContext)
                    newUser.id = UUID()
                    newUser.name = username
                    loggedInUser = newUser
                    try viewContext.save()
                    addMockConversations(loggedInUser: newUser)
                    UserDefaults.standard.set(username, forKey: "loggedInUser")
                    print("New user created, navigate to Home Screen\(username)")
                    showToastMessage("New user created")
                }
            } else {
                UserDefaults.standard.set(username, forKey: "loggedInUser")
                print("New user created, navigate to Home Screen")
                showToastMessage("New user created")
            }

        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    func addMockConversations(loggedInUser: User) {
           let context = PersistenceController.shared.context
           // Create a few mock users and conversations
           let user2 = User(context: context)
           user2.id = UUID()
           user2.name = "Another User"
           user2.avatar = "avatar_other"  // Example other user
           
           let user3 = User(context: context)
           user3.id = UUID()
           user3.name = "Third User"
           user3.avatar = "avatar_third"  // Another example other user

           // Create multiple conversations
            for i in 1...3 {
                let conversation = Conversation(context: context)
                conversation.id = UUID()
                conversation.lastMessage = "Hello from \(loggedInUser.name ?? "Unknown") to conversation \(i)!"
                conversation.participants = [loggedInUser, user2, user3]
                
                let uniqueMessage = "Hello \(i)"
                conversation.lastMessage = uniqueMessage
                
                do {
                    try context.save()
                } catch {
                    print("Failed to save conversation: \(error)")
                }
            }
       }
    
    func showToastMessage(_ message: String) {
         toastMessage = message
         withAnimation {
             showToast = true
         }
         // Hide the toast after a delay
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             withAnimation {
                 showToast = false
             }
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                 isLoggedIn = true
             }
         }
     }
}

#Preview {
    LoginView()
}
