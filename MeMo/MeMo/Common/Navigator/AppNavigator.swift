//
//  AppNavigator.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import SwiftData

final class AppNavigator: ObservableObject {
    @Published var routes: [Route] = .init()
    
    func navigateTo(_ view: Route) {
        routes.append(view)
    }
    
    func back() {
        _ = routes.popLast()
    }
    
    func backToRoot() {
        routes = []
    }
}

enum Route {
    case folder(AppNavigator, FolderView.FolderViewModel)
    case note(AppNavigator, NoteView.NoteViewModel)
    case global(AppNavigator, GlobalView.GlobalViewModel)
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        return true
    }
}

extension Route: View {
    var body: some View {
        switch self {
        case .folder(let navigator, let viewModel):
            FolderView(viewModel: viewModel, navigator: navigator)
                .environment(viewModel)

        case .note(let navigator, let viewModel):
            NoteView(viewModel: viewModel, navigator: navigator)
                .environment(viewModel)
            
        case .global(let navigator, let viewModel):
            GlobalView(viewModel: viewModel, navigator: navigator)
        }
    }
}
