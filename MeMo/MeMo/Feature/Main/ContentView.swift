//
//  ContentView.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var navigator: AppNavigator = .init()

    var body: some View {
        NavigationStack(path: $navigator.routes) {
            Text("Hello, world")
        }
        .navigationDestination(for: Route.self) { $0 }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
