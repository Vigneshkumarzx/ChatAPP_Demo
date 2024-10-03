//
//  OnboardingView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selection = 0
    
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
                
                // Page Control
                /*   HStack {
                 ForEach(0..<onboardingPages.count, id: \.self) { index in
                 Circle()
                 .fill(selection == index ? Color.blue : Color.gray.opacity(0.5))
                 .frame(width: 10, height: 10)
                 }
                 }
                 .padding(.bottom, 20) */
                
                // "Get Started" Button
                if selection == onboardingPages.count - 1 {
                    NavigationLink(destination: LoginView()) {
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
