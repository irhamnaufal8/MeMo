//
//  FolderCard.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct FolderCard: View {
    
    var image: String
    var notes: Int
    var title: String
    var color: Color = .gray2
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
