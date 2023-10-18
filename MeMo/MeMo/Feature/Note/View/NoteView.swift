//
//  NoteView.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI

struct NoteView: View {
    
    @ObservedObject var viewModel: NoteViewModel
    @ObservedObject var navigator: AppNavigator
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    navigator.back()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.headline)
                        .foregroundColor(.black1)
                }
                
                Spacer()
                
                MenuView()
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading) {
                    MultilineTextField(
                        "Your Title",
                        text: $viewModel.data.title,
                        font: .robotoTitle1
                    )
                    
                    HStack {
                        Image(systemName: "tag.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(viewModel.accentColor)
                        
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.black3)
                        
                        Button {
                            viewModel.isShowTagSheet = true
                        } label: {
                            Text(viewModel.tagsText)
                                .font((viewModel.data.tags ?? []).isEmpty ? .robotoBody : .robotoHeadline)
                                .foregroundColor((viewModel.data.tags ?? []).isEmpty ? .black2 : .white)
                                .lineLimit(1)
                                .padding(6)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor((viewModel.data.tags ?? []).isEmpty ? .clear : viewModel.accentColor)
                                )
                        }
                    }
                    
                    Button {
                        viewModel.isShowModified.toggle()
                    } label: {
                        Text(viewModel.timeStampText)
                            .font(.robotoCaption)
                            .foregroundColor(.black3)
                    }
                    
                    Divider()
                    
                    ForEach(viewModel.data.notes, id: \.id) { note in
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
        }
        .overlay(alignment: .topTrailing) {
            NoteColorPicker()
        }
        .background(
            viewModel.bgColor.ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $viewModel.isShowTagSheet) {
            TagsSheet()
        }
    }
}

extension NoteView {
    @ViewBuilder
    func TagsSheet() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tags")
                    .font(.robotoTitle1)
                    .foregroundColor(.black1)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Button {
                    viewModel.isShowTagSheet = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.black3.opacity(0.5))
                        .font(.title2)
                }
            }
            .padding([.top, .horizontal])
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Tags")
                            .font(.robotoHeadline)
                            .foregroundColor(.black2)
                        
                        if let tags = viewModel.data.tags, !tags.isEmpty {
                            ForEach(tags, id: \.self) { tag in
                                HStack {
                                    Text(tag)
                                        .font(.robotoHeadline)
                                        .foregroundColor(.white)
                                    
                                    Button {
                                        viewModel.deleteTag(tag)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.gray2)
                                            .font(.caption)
                                    }
                                }
                                .padding(6)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(viewModel.accentColor)
                                )
                            }
                        } else {
                            Text("Empty")
                                .font(.robotoBody)
                                .foregroundColor(.black2)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.black3)
                        
                        TextField("Create new tag", text: $viewModel.newTag)
                            .font(.robotoBody)
                            .foregroundColor(.black2)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(viewModel.bgColor)
                    )
                    .onSubmit {
                        viewModel.addNewTag()
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func MenuView() -> some View {
        Menu {
            Button {
                withAnimation {
                    viewModel.isShowColorPicker = true
                }
            } label: {
                Label("Change Theme Color", systemImage: "paintpalette")
            }
            
            Button(role: .destructive) {
                
            } label: {
                Label("Delete Note", systemImage: "delete.left")
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black1)
                .padding(4)
        }

    }
    
    @ViewBuilder
    func NoteColorPicker() -> some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.2).ignoresSafeArea()
                .onTapGesture(perform: {
                    withAnimation {
                        viewModel.isShowColorPicker = false
                    }
                })
                .isHidden(!viewModel.isShowColorPicker, remove: !viewModel.isShowColorPicker)
            VStack(alignment: .leading, spacing: 8) {
                Text("Select a color")
                    .font(.robotoHeadline)
                    .foregroundColor(.black3)
                
                HStack(spacing: 4) {
                    ForEach(viewModel.themes, id: \.self) { theme in
                        Button {
                            withAnimation {
                                viewModel.data.theme = theme.rawValue
                            }
                        } label: {
                            Image(systemName: viewModel.data.theme == theme.rawValue ? "checkmark.circle.fill" : "circle.fill")
                                .font(.title2)
                                .foregroundColor(viewModel.accentColor(from: theme.rawValue))
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
            )
            .transition(.scale(scale: 0, anchor: .topTrailing).animation(.spring(response: 0.5, dampingFraction: 0.6)))
            .padding()
            .offset(y: 20)
            .isHidden(!viewModel.isShowColorPicker, remove: !viewModel.isShowColorPicker)
        }
    }
}

#Preview {
    NoteView(viewModel: .init(data: .dummy4), navigator: .init())
}
