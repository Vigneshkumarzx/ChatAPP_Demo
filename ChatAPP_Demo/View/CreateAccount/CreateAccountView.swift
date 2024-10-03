//
//  CreateAccountView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//

import SwiftUI

struct CreateAccountView: View {
       // @Binding var backButtonTapped: Bool
        @State private var createAccountTapped: Bool = false
        @State private var importAccountTapped: Bool = false
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        var body: some View {
            NavigationView {
                ZStack(alignment: .topLeading) {
                    VStack {
                        Image("import_or_create")
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .aspectRatio(contentMode: .fit)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Setup your wallet")
                                .font(.headline)
                            Text("Winkpay supports multiple blockchains and is always adding support for more")
                                .font(.headline)
                            // MARK: Create account
                            NavigationLink {
                                
                            } label: {
                                HStack {
                                    Image("create_account")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .padding(8)

                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Create new crypto wallet")
                                            .font(.title)
                                            .multilineTextAlignment(.leading)
                                        Text("Create new wallet to store, send, receive & invest")
                                            .font(.title3)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .padding(.top, 12)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Divider()

                            // MARK: Import account
                            NavigationLink(isActive: $importAccountTapped) {
                            } label: {
                                HStack {
                                    Image("import_account")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .padding(8)

                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Import your wallet")
                                            .font(.title2)
                                            .multilineTextAlignment(.leading)
                                        Text("Import using Recovery Phrase or Private Key")
                                            .font(.title2)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .padding(.top, 12)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Divider()
                        }
                        .padding()
                        Spacer()
                    }
//                    BackButtonCircle {
//                        presentationMode.wrappedValue.dismiss()
//                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitle("")
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
            .navigationViewStyle(StackNavigationViewStyle())
        }
}

#Preview {
    CreateAccountView()
}
