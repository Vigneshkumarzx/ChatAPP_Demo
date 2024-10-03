//
//  ChatAPP_DemoApp.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 01/10/24.
//

import SwiftUI

@main
struct ChatAPP_DemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
