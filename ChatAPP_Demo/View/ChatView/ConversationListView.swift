//
//  ConversationListView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 01/10/24.
//

import SwiftUI

struct ConversationListView: View {
    @StateObject var viewModel: ChatViewModel = .init()
    @State private var showLogoutAlert = false
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.conversations, id: \.self) { conversation in
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
                        viewModel.logoutUser()
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onAppear {
            viewModel.loadConversations() // Load conversations when the view appears
        }
    }
}
