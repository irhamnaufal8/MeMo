//
//  MeMoApp.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import SwiftData

@main
struct MeMoApp: App {
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: NoteFileResponse.self, NoteResponse.self, TagResponse.self, FolderResponse.self)
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
        .modelContainer(container)
        
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
