//
//  FolderCard.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

/// A custom view for displaying a folder card.
struct FolderCard: View {
    
    /// The image of the folder.
    var image: String

    /// The number of notes in the folder.
    var notes: Int

    /// The title of the folder.
    var title: String

    /// The color of the folder card.
    var color: Color = .gray2

    /// The callback to be executed when the user taps on the folder card.
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Text(image)
                    .font(.system(size: 36))
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(notes) Notes")
                        .font(.robotoBody)
                        .foregroundColor(.black2)
                    
                    Text(title)
                        .font(.robotoTitle3)
                        .foregroundColor(.black1)
                }
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(color)
            )
        }
        .scaledButtonStyle()
    }
}


#Preview {
    FolderCard(image: "💌", notes: 8, title: "Dummy Title") {}
}
