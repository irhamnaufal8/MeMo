//
//  NoteView.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct NoteView: View {
    
    @EnvironmentObject var viewModel: NoteViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Button {
                        viewModel.isShowEmojiPicker = true
                    } label: {
                        Text(viewModel.data.image)
                            .font(.system(size: 28))
                            .padding(4)
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .clipShape(.circle)
                    }
                    .popover(isPresented: $viewModel.isShowEmojiPicker, content: {
                        EmojiPicker(value: $viewModel.data.image)
                            .presentationDetents([.height(280)])
                    })
                    
                    MultilineTextField(
                        "Your Title",
                        text: $viewModel.data.title,
                        font: .robotoTitle1
                    )
                }
                .padding(.bottom)
                
                ForEach(viewModel.data.notes.indices, id: \.self) { index in
                    var note = viewModel.data.notes[index]
                    if var text = note as? NoteTextContent {
                        MultilineTextField(
                            "Your text here..",
                            text: Binding<String>(get: {
                                return text.text
                            }, set: { newValue in
                                text.text = newValue
                            }),
                            font: .robotoBody
                        )
                    } else if let image = note as? NoteImageContent {
                        image.image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(4)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(
            viewModel.bgColor
        )
    }
}

#Preview {
    NoteView()
        .environmentObject(NoteViewModel())
}
