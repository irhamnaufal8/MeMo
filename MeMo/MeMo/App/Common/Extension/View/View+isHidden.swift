//
//  View+isHidden.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI

/// An extension to the `View` type that adds a `isHidden(_:remove:)` modifier.
extension View {
    /// Hides the view if the given condition is `true`, and shows the view if the condition is `false`.
    ///
    /// If the `remove` parameter is `true`, the view will be removed from the view hierarchy instead of just being hidden.
    ///
    /// - Parameters:
    ///   - hidden: A condition that determines whether to hide the view.
    ///   - remove: A Boolean value that determines whether to remove the view from the view hierarchy if it is hidden.
    /// - Returns: A view that is hidden or removed if the given condition is `true`, and shown if the condition is `false`.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

