//
//  MeMoPrimaryButton.swift
//  MeMo
//
//  Created by Irham Naufal on 21/10/23.
//

import SwiftUI

enum ButtonType {
    case adaptive
    case wrapped
    case fixed(CGFloat)
}

struct MeMoButton: View {
    
    var role: ButtonType = .adaptive
    var text: String
    var bgColor: Color
    var action: () -> Void
    
    var body: some View {
        switch role {
        case .adaptive:
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
                role: .adaptive,
                text: "Adaptive",
                bgColor: disable ? .gray1 : .red1
            ) {
                disable.toggle()
            }
            
            MeMoButton(role: .wrapped, text: "Wrapped", bgColor: disable2 ? .gray1 : .purple1) {
                disable2.toggle()
            }
            
            MeMoButton(
                role: .fixed(120),
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
