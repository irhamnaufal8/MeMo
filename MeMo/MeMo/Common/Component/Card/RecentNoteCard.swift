//
//  RecentNoteCard.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct RecentNoteCard: View {
    
    var title: String
    var description: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.robotoTitle3)
                    .foregroundColor(.black1.opacity(0.8))
                    .lineLimit(1)
                
                Text(description)
                    .font(.robotoBody)
                    .foregroundColor(.black2)
                    .lineLimit(2)
            }
            .padding()
            .frame(width: 200, height: 92, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.orange3)
            )
        }
        .scaledButtonStyle()
    }
}

#Preview {
    RecentNoteCard(
        title: "This is Dummy Title ✨",
        description: "This is dummy description of recent notes, for testing purposes only."
    ) {
        
    }
}
