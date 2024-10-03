//
//  OnBoardingModel.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//

import Foundation

struct OnBoardingModel {
    let title: String
    let description: String
    let imageName: String
}

let onboardingPages = [
    OnBoardingModel(title: "Welcome to ChatApp", description: "Connect with friends and family instantly.", imageName: "image1"),
    OnBoardingModel(title: "Share Your Moments", description: "Share photos and messages effortlessly.", imageName: "image2"),
    OnBoardingModel(title: "Stay Connected", description: "Never miss a moment with real-time chat.", imageName: "image3")
]
