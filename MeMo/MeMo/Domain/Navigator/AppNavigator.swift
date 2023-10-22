//
//  AppNavigator.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import SwiftData

/// The navigation system. It maintains a stack of routes and provides functions to navigate to and back from routes.
final class AppNavigator: ObservableObject {
    /// The current routes.
    @Published var routes: [Route] = .init()

    /// Navigate to a new route.
    func navigateTo(_ view: Route) {
        routes.append(view)
    }

    /// Go back to the previous route.
    func back() {
        _ = routes.popLast()
    }

    /// Go back to the root route.
    func backToRoot() {
        routes = []
    }
}

/// A type that represents a route in the navigation system.
///
/// The `Route` enum has three cases:
///
/// * `.folder`: A route to a folder view.
/// * `.note`: A route to a note view.
/// * `.global`: A route to a global view.

enum Route {
    /// A route to a folder view.
    case folder(AppNavigator, FolderView.FolderViewModel)

    /// A route to a note view.
    case note(AppNavigator, NoteView.NoteViewModel)

    /// A route to a global view.
    case global(AppNavigator, GlobalView.GlobalViewModel)
    
    case sample(ModelContext)
}

/// Implement the `Hashable` protocol for the `Route` enum.
extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }

    static func == (lhs: Route, rhs: Route) -> Bool {
        return true
    }
}

/// Implement the `View` protocol for the `Route` enum.
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
            
        case .sample(let context):
            SampleView(viewModel: .init(
                noteRepository: DefaultNoteRepository(
                    localDataSource: DefaultNoteLocalDataSource(
                        provider: context
                    )
                )
            ))
        }
    }
}
