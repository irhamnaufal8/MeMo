//
//  SearchTextField.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct SearchTextField: View {
    
    var placeholder: String = "Search your notes.."
    @Binding var text: String
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
