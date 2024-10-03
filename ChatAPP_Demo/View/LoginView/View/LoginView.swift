//
//  LoginView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

       // Initialize with Core Data context
       init(context: NSManagedObjectContext) {
           _viewModel = StateObject(wrappedValue: LoginViewModel(context: context))
       }

       var body: some View {
           NavigationStack {
               VStack {
                   Text("Enter your Username")
                       .font(.title)
                       .frame(alignment: .leading)
                   Text("Please enter your username to validate you as a new or registered user.")
                       .font(.system(size: 12, weight: .regular))
                       .foregroundStyle(.gray)
                       .padding(.top, 4)
                   TextField("Enter username", text: $viewModel.username)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .padding()
                   
                   Button(action: {
                       viewModel.loginUser()
                   }) {
                       Text("Continue")
                           .font(.system(size: 16, weight: .bold))
                           .padding()
                           .background(Color.green)
                           .foregroundColor(.white)
                           .cornerRadius(8)
                   }
                   Spacer()
                   if viewModel.showToast {
                       ToastView(message: viewModel.toastMessage)
                           .transition(.opacity)
                           .animation(.easeInOut(duration: 0.5), value: viewModel.showToast)
                   }
               }
               .padding()
               .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                   if let user = viewModel.loggedInUser {
                       ConversationListView()
                   }
               }
           }
       }
}

