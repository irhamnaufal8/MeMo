//
//  ContentView.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @ObservedObject var navigator: AppNavigator = .init()
    let container: ModelContainer

    var body: some View {
        NavigationStack(path: $navigator.routes) {
            HomeView(modelContext: container.mainContext, navigator: navigator)
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(HomeView.HomeViewModel(modelContext: container.mainContext))
    }
}
//
//#Preview {
//    ContentView()
//}
