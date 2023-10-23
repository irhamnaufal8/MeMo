//
//  AppAssembler.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import SwiftUI
import SwiftData

protocol Assembler: SampleAssembler,
                    DummyAssembler {}

final class AppAssembler: Assembler, ObservableObject {}

final class MeMoNavigator: ObservableObject {
    
    /// The current routes.
    @Published var routes: [MemoRoute] = .init()

    /// Navigate to a new route.
    func navigateTo(_ view: MemoRoute) {
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

enum MemoRoute {
    case sample(MeMoNavigator)
    case dummy(MeMoNavigator, Int)
}

extension MemoRoute: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }

    static func == (lhs: MemoRoute, rhs: MemoRoute) -> Bool {
        return true
    }
}

extension MemoRoute: View, Assembler {
    var body: some View {
        switch self {
        case .sample(let navigator):
            return AnyView(SampleView(viewModel: resolve(), navigator: navigator))
            
        case .dummy(let navigator, let number):
            return AnyView(DummyView(viewModel: resolve(number: number), navigator: navigator))
        }
    }
}
