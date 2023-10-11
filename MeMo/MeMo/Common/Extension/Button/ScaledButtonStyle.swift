//
//  ScaledButtonStyle.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

extension Button {
    func scaledButtonStyle() -> some View {
        self.buttonStyle(ScaledButtonStyle())
    }
}
