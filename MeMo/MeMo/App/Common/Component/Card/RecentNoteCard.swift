//
//  RecentNoteCard.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

/// Custom card for displaying a recent note card.
struct RecentNoteCard: View {
    
    /// The title of the note.
    var title: String

    /// The description of the note.
    var description: String

    /// The date of the note (optional).
    var date: Date?

    /// The color of the note card.
    var color: Color = .orange3

    /// The callback to be executed when the user taps on the note card.
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.robotoTitle3)
                        .foregroundColor(.black1.opacity(0.8))
                        .lineLimit(1)
                    
                    Text(description)
                        .font(.robotoBody)
                        .foregroundColor(.black2)
                        .lineLimit(2)
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(height: 64, alignment: .topLeading)
                
                if let date = date {
                    Text("Edited \(relativeTime(from: date))")
                        .font(.robotoCaption)
                        .foregroundColor(.black3)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(color)
            )
        }
        .scaledButtonStyle()
    }

    private func relativeTime(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale.current
        return formatter.localizedString(for: date, relativeTo: .now)
    }
}


#Preview {
    RecentNoteCard(
        title: "This is Dummy Title ✨",
        description: "This is dummy description of recent notes, for testing purposes only.",
        date: .now - 10000
    ) {
        
    }
    .frame(width: 200)
}
