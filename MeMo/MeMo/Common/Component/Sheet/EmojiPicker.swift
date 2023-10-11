//
//  EmojiPicker.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct EmojiPicker: View {
    
    @Binding var value: String
    
    private let emojis: [String] = [
        "💌", "📚", "💡", "💅🏻", "🎓", "💼", "💍", "🕶️", "🍀", "🌸", "⭐️", "🌙", "🔥", "🌈", "❄️", "🍓", "🍽️", "⚽️", "🏆", "🎨", "🎬", "🎹", "🎮", "🎁",
    ]
    
    private let columns = [
        GridItem(.adaptive(minimum: 40)),
        GridItem(.adaptive(minimum: 40)),
        GridItem(.adaptive(minimum: 40)),
        GridItem(.adaptive(minimum: 40)),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("Select your emoji")
                .font(.robotoHeadline)
                .foregroundColor(.black2)
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
    @State var show = false
    @State var text = ""
    var body: some View {
        VStack {
            Text(text)
            
            Button("Show") {
                show = true
            }
            .popover(isPresented: $show, content: {
                EmojiPicker(value: $text)
                    .presentationDetents([.height(280)])
            })
        }
    }
}

#Preview {
    EmojiPickerPreview()
}
