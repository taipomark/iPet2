//
//  iPetApp.swift
//  iPet
//
//  Created by Mark Lai on 12/9/2021.
//

import SwiftUI

@main
struct iPetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
