//
//  ScaledButtonStyle.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

/// A button style that scales the button down when it is pressed.
struct ScaledButtonStyle: ButtonStyle {
    /// Makes a view that represents the button.
    ///
    /// - Parameter configuration: A configuration object that contains information about the button.
    /// - Returns: A view that represents the button.
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

/// An extension to the `Button` type that adds a `scaledButtonStyle()` method.
extension Button {
    /// Applies the `ScaledButtonStyle` to the button.
    ///
    /// - Returns: A view that represents the button with the `ScaledButtonStyle` applied.
    func scaledButtonStyle() -> some View {
        self.buttonStyle(ScaledButtonStyle())
    }
}

