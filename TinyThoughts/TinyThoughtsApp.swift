//
//  TinyThoughtsApp.swift
//  TinyThoughts
//
//  Created by Lukas Moro on 02.04.25.
//

import SwiftUI

@main
struct TinyThoughtsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
