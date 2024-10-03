//
//  ToastView.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//

import Foundation
import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.bottom, 50)
            .frame(maxWidth: .infinity)
    }
}
