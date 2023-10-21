//
//  MemoAlertModifier.swift
//  MeMo
//
//  Created by Irham Naufal on 21/10/23.
//

import SwiftUI

/// A custom view modifier for displaying an alert.
struct MemoAlertModifier: ViewModifier {
    
    /// The binding to the boolean value that determines whether or not the alert is presented.
    @Binding var isPresent: Bool

    /// The title of the alert.
    @State var title: String

    /// The message of the alert.
    @State var message: String

    /// The primary button of the alert.
    var primaryButton: MeMoButton

    /// The secondary button of the alert (optional).
    var secondaryButton: MeMoButton?

    func body(content: Content) -> some View {
        content
            .overlay {
                // Overlay a black background with 0.2 opacity.
                Color.black.opacity(0.2).ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .isHidden(!isPresent, remove: true)

                // Display the alert content.
                VStack(spacing: 22) {
                    VStack(spacing: 8) {
                        // Display the title of the alert.
                        Text(title)
                            .font(.robotoTitle2)
                            .foregroundColor(.black1)

                        // Display the message of the alert.
                        Text(message)
                            .font(.robotoBody)
                            .foregroundColor(.black2)
                    }

                    // Display the primary and secondary buttons of the alert.
                    HStack {
                        if let button = secondaryButton {
                            button
                        }

                        primaryButton
                    }
                }
                .multilineTextAlignment(.center)
                .padding()
                .padding(.vertical)
                .frame(maxWidth: 512)
                .background(Color.white)
                .cornerRadius(12)
                .opacity(isPresent ? 1 : 0)
                .transition(.scale(0).animation(.spring(response: 0.5, dampingFraction: 0.6)))
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isPresent)
                .padding()
                .isHidden(!isPresent, remove: true)
            }
    }
}

/// A struct that represents the properties of a Memo Alert.
struct MeMoAlertProperty {
    
    /// The title of the alert.
    @State var title: String = "Are You Sure?"

    /// The message of the alert.
    @State var message: String = "You won't be able to restore it again because we haven't implement recently delete feature yet 👉🏻👈🏻"

    /// The primary button of the alert.
    var primaryButton: MeMoButton = .init(text: "", bgColor: .red1, action: {})

    /// The secondary button of the alert (optional).
    var secondaryButton: MeMoButton? = nil
}

extension View {

    /// Displays a Memo Alert.
    ///
    /// - Parameters:
    ///   - isPresent: A binding to the boolean value that determines whether or not the alert is presented.
    ///   - title: The title of the alert.
    ///   - message: The message of the alert (optional).
    ///   - primaryButton: The primary button of the alert.
    ///   - secondaryButton: The secondary button of the alert (optional).
    ///
    /// - Returns: A view that displays a Memo Alert.
    func memoAlert(
        isPresent: Binding<Bool>,
        title: String,
        message: String = "You won't be able to restore it again because we haven't implement recently delete feature yet 👉🏻👈🏻",
        primaryButton: MeMoButton,
        secondaryButton: MeMoButton?
    ) -> some View {
        return modifier(
            MemoAlertModifier(
                isPresent: isPresent,
                title: title,
                message: message,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        )
    }

    /// Displays a Memo Alert with a `MeMoAlertProperty` struct.
    ///
    /// - Parameters:
    ///   - isPresent: A binding to the boolean value that determines whether or not the alert is presented.
    ///   - property: A `MeMoAlertProperty` struct that contains the properties of the alert.
    ///
    /// - Returns: A view that displays a Memo Alert.
    func memoAlert(isPresent: Binding<Bool>, property: MeMoAlertProperty) -> some View {
        return modifier(
            MemoAlertModifier(
                isPresent: isPresent,
                title: property.title,
                message: property.message,
                primaryButton: property.primaryButton,
                secondaryButton: property.secondaryButton
            )
        )
    }
}


fileprivate struct MemoAlertPreview: View {
    
    @State var show = false
    var title = "Delete This Memo?"
    var message = "You won't able to restore it again because we haven't implement recently delete feature 👉🏻👈🏻"
    
    var body: some View {
        VStack {
            Button {
                show = true
            } label: {
                Text("Show Alert")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .memoAlert(
            isPresent: $show,
            title: title,
            message: message,
            primaryButton: .init(
                text: "Okay",
                bgColor: .blue1,
                action: {
                    show = false
                }
            ), secondaryButton: .init(
                text: "Cancel",
                bgColor: .gray1,
                action: {
                    show = false
                }
            )
        )
    }
}

#Preview {
    MemoAlertPreview()
}
