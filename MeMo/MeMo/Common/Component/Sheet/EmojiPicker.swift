//
//  EmojiPicker.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

/// A custom view for picking an emoji.
struct EmojiPicker: View {
    
    /// The binding to the selected emoji.
    @Binding var value: String

    /// The callback to be executed when the user closes the emoji picker.
    let close: () -> Void

    /// The list of emojis to be displayed in the emoji picker.
    private let emojis: [String] = [
        "💌", "📚", "💡", "💅🏻", "🎓", "💼", "💍", "🕶️", "🍀", "🌸", "⭐️", "🌙", "🔥", "🌈", "❄️", "🍓", "🍽️", "⚽️", "🏆", "🎨", "🎬", "🎹", "🎮", "🎁",
    ]

    /// The layout of the emoji picker.
    private let columns = [
        GridItem(.adaptive(minimum: 40)),
        GridItem(.adaptive(minimum: 40)),
        GridItem(.adaptive(minimum: 40)),
        GridItem(.adaptive(minimum: 40)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            HStack {
                Text("Select your emoji")
                    .font(.robotoHeadline)
                    .foregroundColor(.black2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    close()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray1)
                }
            }
            .padding([.horizontal, .top])

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12, content: {
                    ForEach(emojis, id: \.self) { emoji in
                        Button {
                            value = emoji
                        } label: {
                            Text(emoji)
                                .font(.title)
                        }
                    }
                })
                .padding([.horizontal, .bottom])
            }
        })
    }
}


fileprivate struct EmojiPickerPreview: View {
    @State var show = true
    @State var text = ""
    var body: some View {
        VStack {
            Text(text)
            
            Button("Show") {
                show = true
            }
            .popover(isPresented: $show, content: {
                EmojiPicker(value: $text) {
                    show = false
                }
                .presentationDetents([.height(280)])
            })
        }
    }
}

#Preview {
    EmojiPickerPreview()
}
