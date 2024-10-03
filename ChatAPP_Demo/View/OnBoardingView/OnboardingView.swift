//
//  OnboardingView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selection = 0
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selection) {
                    ForEach(onboardingPages.indices, id: \.self) { index in
                        VStack {
                            Image(onboardingPages[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .padding()
                            
                            Text(onboardingPages[index].title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top)
                            
                            Text(onboardingPages[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Spacer() // Ensure this pushes content up
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                // "Get Started" Button
                if selection == onboardingPages.count - 1 {
                    NavigationLink(destination: LoginView(context: viewContext)) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingView()
}
