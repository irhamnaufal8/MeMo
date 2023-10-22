//
//  ContentView.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    // An ObservableObject that manages the application's navigation state.
//    @ObservedObject var navigator: AppNavigator = .init()

    // A container for managing data models.
//    let container: ModelContainer

    @State private var assembler: AppAssembler
    
    init(assembler: AppAssembler) {
        self.assembler = assembler
    }
    // The body of the view.
    var body: some View {
        // A NavigationStack that contains the HomeView and any other views that the application needs to navigate to.
        // The NavigationStack's path property is bound to the navigator.routes property.
        NavigationStack(path: $assembler.navigator.routes) {
            // The HomeView, which is the application's main view.
            // The HomeView is injected with the ModelContainer and the AppNavigator.
//            HomeView(modelContext: container.mainContext, navigator: navigator)
            
            assembler.rootView
                // A navigation destination for the HomeView.
                // The navigation destination is specified using the Route enum.
                .navigationDestination(for: Route.self) { $0 }
        }
        // Sets the HomeViewModel for the environment.
        // The HomeViewModel is injected with the ModelContainer.
//        .environment(HomeView.HomeViewModel(modelContext: container.mainContext))
    }
}

//
//#Preview {
//    ContentView()
//}
