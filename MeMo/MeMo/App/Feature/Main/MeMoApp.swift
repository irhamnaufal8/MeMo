//
//  MeMoApp.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

// Import the SwiftUI and SwiftData frameworks.
import SwiftUI
import SwiftData

// The main entry point for the application.
@main
struct MeMoApp: App {

    // A container for managing data models.
//    let container: ModelContainer

    // Initializes the application.
//    init() {
//        do {
            // Attempts to create a ModelContainer for the NoteFileResponse, NoteResponse, TagResponse, and FolderResponse models.
//            container = try ModelContainer(for: NoteFile.self, NoteContent.self, Tag.self, Folder.self)
//        } catch {
            // Fatally crashes the application if the ModelContainer could not be created.
//            fatalError("Failed to create ModelContainer.")
//        }
//    }

    // The body of the application.
    var body: some Scene {
        // Creates a WindowGroup that contains the ContentView.
        WindowGroup {
//            ContentView(container: container)
            ContentView()
        }
        // Sets the ModelContainer for the WindowGroup.
//        .modelContainer(container)
    }
}

// An extension to the UINavigationController class that implements the UIGestureRecognizerDelegate protocol.
extension UINavigationController: UIGestureRecognizerDelegate {

    // Override the viewDidLoad() method to set the delegate of the interactivePopGestureRecognizer to self.
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    // Implements the gestureRecognizerShouldBegin(_:) method to return true if the view controller stack contains more than one view controller.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

