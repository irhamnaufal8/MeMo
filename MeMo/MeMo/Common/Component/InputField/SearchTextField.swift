//
//  SearchTextField.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

/// A custom text field for searching notes.
struct SearchTextField: View {
    
    /// The placeholder text for the text field.
    var placeholder: String = "Search your notes.."

    /// The binding to the text in the text field.
    @Binding var text: String

    /// The background color of the text field.
    var bgColor: Color = .white

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.headline)

            TextField(placeholder, text: $text)
                .font(.robotoBody)
        }
        .foregroundColor(.black2)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(bgColor)
        )
    }
}

#Preview {
    SearchTextField(text: .constant(""))
}
