//
//  ChatView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//

import Foundation
import SwiftUI
import CoreData

struct ChatView: View {
    @ObservedObject var conversation: Conversation
    @FetchRequest var messages: FetchedResults<Message>
    
    @StateObject var viewModel: ChatViewModel = .init()
    
    // Custom initializer to filter messages for the selected conversation
    init(conversation: Conversation) {
        self.conversation = conversation
        _messages = FetchRequest<Message>(
            entity: Message.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Message.timeStamp, ascending: true)],
            predicate: NSPredicate(format: "conversation == %@", conversation)
        )
    }
    
    var body: some View {
        VStack {
            // Messages List
            ScrollView {
                LazyVStack {
                    ForEach(messages) { message in
                        HStack(alignment: .bottom) {
                            if message.isSentByCurrentUser {
                                Spacer() // Pushes sent messages to the right
                                VStack(alignment: .trailing) {
                                    HStack(alignment: .bottom) {
                                        Text(message.content ?? "")
                                            .padding(8)
                                            .background(Color.green)
                                            .cornerRadius(10)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: 300, alignment: .trailing)
                                        
                                        Image("avatar")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    }
                                    
                                    Text(viewModel.formatDate(message.timeStamp))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                            } else {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .bottom) {
                                        Image("avatar")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        
                                        Text(message.content ?? "")
                                            .padding(8)
                                            .background(Color.gray.opacity(0.3))
                                            .cornerRadius(10)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: 300, alignment: .leading)
                                    }
                                    Text(viewModel.formatDate(message.timeStamp))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer() // Pushes received messages to the left
                            }
                        }
                        .padding(message.isSentByCurrentUser ? .leading : .trailing, 50)
                        .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal, 12)
            }
            
            // Message Input Field and Send Button
            HStack {
                TextField("Type a message...", text: $viewModel.typedMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    guard !viewModel.typedMessage.isEmpty else { return }
                    
                    // Ensure the recipient exists (assuming Conversation has a recipient property)
                    if let recipient = conversation.participants {
                        viewModel.sendMessage(conversation: conversation)
                        viewModel.typedMessage = "" // Clear the input field after sending
                    }
                }) {
                    Text("Send")
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}
