//
//  AppAssembler.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import SwiftUI
import SwiftData

@Observable
final class AppAssembler {
    
    var rootView: AnyView = AnyView(EmptyView())
    var navigator: AppNavigator = .init()
    private var modelContainer: ModelContainer?
    
    init() {
        Task { @MainActor in
            setUpView()
        }
    }
    
    @MainActor
    private func setUpView() {
        guard let modelContainer = try? ModelContainer(for: NoteFile.self, NoteContent.self, Tag.self, Folder.self) else {
            // Error handling
            return
        }
        self.modelContainer = modelContainer
        self.navigator.navigateTo(.sample(modelContainer.mainContext))
        guard let view = self.navigator.routes.first else { return }
        self.rootView = AnyView(view.body)
    }
    
}
