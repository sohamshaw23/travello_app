//
//  traveloApp.swift
//  travelo
//
//  Created by Soham Shaw on 02/05/26.
//

import SwiftUI
import CoreData

@main
struct traveloApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
