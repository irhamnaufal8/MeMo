//
//  MeMoApp.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

@main
struct MeMoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
