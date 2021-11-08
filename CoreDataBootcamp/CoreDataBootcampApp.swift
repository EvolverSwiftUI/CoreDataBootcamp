//
//  CoreDataBootcampApp.swift
//  CoreDataBootcamp
//
//  Created by Sivaram Yadav on 11/6/21.
//

import SwiftUI

@main
struct CoreDataBootcampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
