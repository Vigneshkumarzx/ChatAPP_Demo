//
//  ConversationListView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 01/10/24.
//

import SwiftUI

struct ConversationListView: View {
    @FetchRequest(
        entity: Conversation.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Conversation.lastMessage, ascending: false)],
        animation: .default)
    var conversations: FetchedResults<Conversation>
    @Environment(\.presentationMode) private var presentationMode
    let context = PersistenceController.shared.context
    @StateObject var viewModel: ChatViewModel = .init()
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [], // Add your sort descriptors if needed
        predicate: NSPredicate(format: "name == %@", UserDefaults.standard.string(forKey: "loggedInUser") ?? "")
    )
    var loggedInUser: FetchedResults<User>
   
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(conversations, id: \.self) { conversation in
                    NavigationLink(destination: ChatView(conversation: conversation)) {
                        HStack {
                            Image("avatar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            VStack(alignment: .leading) {
                                Text(conversation.lastMessage ?? "No message")
                                    .font(.headline)
                                
                                if let participants = conversation.participants {
                                    let participantNames = participants.map { $0.name ?? "Unknown" }
                                    let participantText = participantNames.joined(separator: ", ")
                                    Text(participantText)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
            }
            .navigationTitle("Conversations")
            .navigationBarItems(trailing: Button(action: {
                showLogoutAlert = true
                
            }, label: {
                Text("Logout")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.red)
            }))
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Confirm Logout"),
                    message: Text("Are you sure you want to log out? This will delete all conversations and your account."),
                    primaryButton: .destructive(Text("Logout")) {
                        logoutUser()
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func logoutUser() {
        deleteAllConversations()
        deleteLoggedInUser()
        print("User logged out, all conversations deleted")
    }
    
    private func deleteAllConversations() {
        for conversation in conversations {
            context.delete(conversation)
        }
        do {
            try context.save()
            print("All conversations deleted")
        } catch {
            print("Error deleting conversations: \(error)")
        }
    }
    
    private func deleteLoggedInUser() {
        if let user = loggedInUser.first {
            context.delete(user)
            do {
                try context.save()  // Save the context after user deletion
                print("Logged-in user deleted")
            } catch {
                print("Error deleting user: \(error)")
            }
        }
    }
}

