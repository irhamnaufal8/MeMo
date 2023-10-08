//
//  ContentView.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var navigator: AppNavigator = .init()

    var body: some View {
        NavigationStack(path: $navigator.routes) {
            Text(LocalizedText.helloWorld)
                .font(.robotoTitle1)
            
            Text(LocalizedText.withValue(value: "lalalala"))
                .font(.robotoCaption)
        }
        .navigationDestination(for: Route.self) { $0 }
    }
}

#Preview {
    ContentView()
        
}