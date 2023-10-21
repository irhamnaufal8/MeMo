//
//  MemoAlertModifier.swift
//  MeMo
//
//  Created by Irham Naufal on 21/10/23.
//

import SwiftUI

struct MemoAlertModifier: ViewModifier {
    
    @Binding var isPresent: Bool
    @State var title: String
    @State var message: String
    var primaryButton: MeMoButton
    var secondaryButton: MeMoButton?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Color.black.opacity(0.2).ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .isHidden(!isPresent, remove: true)
                
                VStack(spacing: 22) {
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.robotoTitle2)
                            .foregroundColor(.black1)
                        
                        Text(message)
                            .font(.robotoBody)
                            .foregroundColor(.black2)
                    }
                    
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

struct MeMoAlertProperty {
    @State var title: String = "Are You Sure?"
    @State var message: String = "You won't be able to restore it again because we haven't implement recently delete feature yet 👉🏻👈🏻"
    var primaryButton: MeMoButton = .init(text: "", bgColor: .red1, action: {})
    var secondaryButton: MeMoButton? = nil
}

extension View {
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
