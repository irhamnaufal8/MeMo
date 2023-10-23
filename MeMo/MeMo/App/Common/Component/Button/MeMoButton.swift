//
//  MeMoPrimaryButton.swift
//  MeMo
//
//  Created by Irham Naufal on 21/10/23.
//

import SwiftUI

/// An enum that represents the different types of buttons.
enum ButtonType {
    /// A button that adapts its size to the content.
    case adaptive
    /// A button that wraps its content to the next line if necessary.
    case wrapped
    /// A button with a fixed width.
    case fixed(CGFloat)
}

/// A custom button view.
struct MeMoButton: View {
    
    /// The type of button.
    var type: ButtonType = .adaptive
    /// The text of the button.
    var text: String
    /// The background color of the button.
    var bgColor: Color
    /// The action to be executed when the button is tapped.
    var action: () -> Void

    var body: some View {
        switch type {
        case .adaptive:
            /// An adaptive button.
            Button {
                action()
            } label: {
                Text(text)
                    .foregroundColor(.white)
                    .font(.robotoHeadline)
                    .lineLimit(1)
                    .padding(14)
                    .frame(maxWidth: .infinity)
                    .background(bgColor)
                    .cornerRadius(8)
            }
            .scaledButtonStyle()

        case .wrapped:
            /// A wrapped button.
            Button {
                action()
            } label: {
                Text(text)
                    .foregroundColor(.white)
                    .font(.robotoHeadline)
                    .lineLimit(1)
                    .padding(14)
                    .background(bgColor)
                    .cornerRadius(8)
            }
            .scaledButtonStyle()

        case .fixed(let width):
            /// A fixed-width button.
            Button {
                action()
            } label: {
                Text(text)
                    .foregroundColor(.white)
                    .font(.robotoHeadline)
                    .lineLimit(1)
                    .padding(14)
                    .frame(maxWidth: width)
                    .background(bgColor)
                    .cornerRadius(8)
            }
            .scaledButtonStyle()
        }
    }
}


fileprivate struct MeMoButtonPreview: View {
    @State var disable = false
    @State var disable2 = false
    @State var disable3 = false
    
    var body: some View {
        VStack {
            MeMoButton(
                type: .adaptive,
                text: "Adaptive",
                bgColor: disable ? .gray1 : .red1
            ) {
                disable.toggle()
            }
            
            MeMoButton(type: .wrapped, text: "Wrapped", bgColor: disable2 ? .gray1 : .purple1) {
                disable2.toggle()
            }
            
            MeMoButton(
                type: .fixed(120),
                text: "Fixed",
                bgColor: disable3 ? .gray1 : .pink1
            ) {
                disable3.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    MeMoButtonPreview()
}
