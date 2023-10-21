//
//  NoteView.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI
import PhotosUI
import SwiftData

struct NoteView: View, KeyboardReadable {
    
    @State var viewModel: NoteViewModel
    @ObservedObject var navigator: AppNavigator
    
    @FocusState private var focusedField: Int?
    
    init(viewModel: NoteViewModel, navigator: AppNavigator) {
        _viewModel = State(initialValue: viewModel)
        self.navigator = navigator
    }
    
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
                        text: $viewModel.title,
                        font: .robotoTitle1,
                        onCommit: {
                            withAnimation {
                                viewModel.isEditTitle = false
                                viewModel.isShowBottomBar = false
                            }
                        },
                        onEdit:  {
                            withAnimation {
                                viewModel.isEditTitle = true
                                viewModel.isShowBottomBar = false
                            }
                        },
                        onDoneEdit: {
                            withAnimation {
                                viewModel.isEditTitle = true
                                viewModel.isShowBottomBar = false
                            }
                        }
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
                    
                    ForEach($viewModel.data.notes, id: \.id) { $note in
                        Group {
                            switch note.type {
                            case .init(content: .image):
                                ImageContentView(note)
                                    
                            case .init(content: .list):
                                HStack(alignment: .top) {
                                    Button {
                                        note.isChecked = !(note.isChecked.orFalse())
                                    } label: {
                                        Image(systemName: note.isChecked.orFalse() ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(viewModel.accentColor)
                                            .font(.title3)
                                    }
                                    .offset(y: -1)
                                    
                                    MultilineTextField(
                                        "Your text here..",
                                        text: $note.text,
                                        font: .robotoBody,
                                        onCommit: {
                                            viewModel.addNextNoteList()
                                            focusField(to: .next)
                                        },
                                        onEdit: {
                                            viewModel.currentIndex = viewModel.getCurrentIndex(of: note)
                                            withAnimation {
                                                viewModel.isShowBottomBar = true
                                            }
                                        },
                                        onBackspace: { isEmpty in
                                            viewModel.turnIntoText(if: isEmpty)
                                            if isEmpty {
                                                focusField(to: .current)
                                            }
                                        }
                                    )
                                    .opacity(note.isChecked.orFalse() ? 0.5 : 1)
                                }
                                .padding(.top, viewModel.prevIsNotCheckList(note) ? 12 : 0)
                                .padding(.bottom, viewModel.nextIsNotCheckList(note) ? 12 : 0)
                                
                            case .init(content: .bulletList):
                                HStack(alignment: .top) {
                                    Circle()
                                        .foregroundColor(.black2)
                                        .frame(width: 6, height: 6)
                                        .padding(.top, 7)
                                    
                                    MultilineTextField(
                                        "Your text here..",
                                        text: $note.text,
                                        font: .robotoBody,
                                        onCommit: {
                                            viewModel.addNextBulletList(after: note)
                                            focusField(to: .next)
                                        },
                                        onEdit: {
                                            viewModel.currentIndex = viewModel.getCurrentIndex(of: note)
                                            withAnimation {
                                                viewModel.isShowBottomBar = true
                                            }
                                        },
                                        onBackspace: { isEmpty in
                                            viewModel.turnIntoText(if: isEmpty)
                                            if isEmpty {
                                                focusField(to: .current)
                                            }
                                        }
                                    )
                                }
                                
                            default:
                                MultilineTextField(
                                    "Your text here..",
                                    text: $note.text,
                                    font: .robotoBody,
                                    onCommit: {
                                        viewModel.addNoteText(after: note)
                                        focusField(to: .next)
                                    },
                                    onEdit: {
                                        viewModel.currentIndex = viewModel.getCurrentIndex(of: note)
                                        withAnimation {
                                            viewModel.isShowBottomBar = true
                                        }
                                    },
                                    onBackspace: { isEmpty in
                                        viewModel.deleteCurrentLine(if: isEmpty)
                                        if isEmpty {
                                            focusField(to: .previous)
                                        }
                                    }
                                )
                                .onChange(of: note.text) { _, _ in
                                    viewModel.turnIntoBulletList()
                                    focusField(to: .current)
                                }
                            }
                        }
                        .id(viewModel.getCurrentIndex(of: note))
                        .focused($focusedField, equals: viewModel.getCurrentIndex(of: note))
                    }
                    viewModel.bgColor
                        .frame(height: 360)
                        .onTapGesture(perform: {
                            viewModel.addNoteTextOnLast()
                            focusField(to: .last)
                        })
                        .padding(.top, 36)
                }
                .padding(.horizontal)
            }
            
            BottomBar()
                .isHidden(!viewModel.isShowBottomBar, remove: !viewModel.isShowBottomBar)
        }
        .onAppear {
            viewModel.addFirstText()
            viewModel.modelContext.autosaveEnabled = false
        }
        .onDisappear {
            viewModel.updateModifiedDate()
            viewModel.saveChanges()
        }
        .tint(viewModel.accentColor)
        .overlay(alignment: .topTrailing) {
            NoteColorPicker()
        }
        .background(
            viewModel.bgColor.ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .onReceive(keyboardPublisher, perform: { value in
            if !viewModel.isEditTitle {
                withAnimation {
                    viewModel.isShowBottomBar = value
                }
            }
        })
        .sheet(isPresented: $viewModel.isShowTagSheet) {
            TagsSheet()
                .presentationDetents([.fraction(0.99)])
        }
        .photosPicker(
            isPresented: $viewModel.isShowPhotoPicker,
            selection: $viewModel.selectedImage,
            matching: .images
        )
        .onChange(of: viewModel.selectedImage) { _, photo in
            Task {
                await viewModel.addNoteImage(with: photo)
            }
        }
        .onChange(of: viewModel.title) { _, title in
            viewModel.updateTitle(title)
        }
        .onChange(of: viewModel.data.notes) { _, _ in
            viewModel.sortContent()
        }
    }
}

extension NoteView {
    @ViewBuilder
    func ImageContentView(_ note: NoteResponse) -> some View {
        if let data = note.image,
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .cornerRadius(4)
                .overlay(alignment: .topTrailing) {
                    Menu {
                        Button {
                            viewModel.currentIndex = viewModel.getCurrentIndex(of: note)
                            viewModel.isShowPhotoPicker = true
                        } label: {
                            Label("Change Photo", systemImage: "photo")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deleteNoteImage(note)
                            focusField(to: .current)
                        } label: {
                            Label("Delete Photo", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray2)
                            .shadow(color: .black.opacity(0.5), radius: 10)
                    }
                    .padding(6)
                }
        } else {
            Color.gray1.opacity(0.3)
                .overlay {
                    VStack(spacing: 18) {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(viewModel.accentColor.opacity(0.5))
                            .frame(maxHeight: 90)
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 28, weight: .black))
                                    .foregroundColor(.red)
                                    .offset(x: 6, y: -6)
                            }
                        
                        Text("Oops.. something went wrong :(")
                            .font(.robotoBody)
                            .foregroundColor(.black1)
                    }
                    .padding()
                }
                .frame(maxHeight: 250)
                .cornerRadius(4)
        }
    }
    
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
            .padding([.top, .horizontal])
            .onSubmit {
                viewModel.addNewTag()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Tags")
                            .font(.robotoHeadline)
                            .foregroundColor(.black2)
                        
                        if let tags = viewModel.data.tags {
                            ForEach(tags, id: \.id) { tag in
                                HStack {
                                    Text(tag.text.orEmpty())
                                        .font(.robotoHeadline)
                                        .foregroundColor(.white)
                                    
                                    Button {
                                        viewModel.deleteTag(tag.text.orEmpty())
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
            
//            Button(role: .destructive) {
//                
//            } label: {
//                Label("Delete Note", systemImage: "delete.left")
//            }
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
    
    @ViewBuilder
    func BottomBar() -> some View {
        HStack {
            Button {
                hideKeyboard()
                viewModel.isShowBottomBar = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    self.viewModel.isShowPhotoPicker = true
                }
            } label: {
                Image(systemName: "photo")
            }
            .frame(maxWidth: .infinity)
            
            Button {
                viewModel.addNoteList()
                focusField(to: .current)
            } label: {
                Image(systemName: "checklist")
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .foregroundColor(viewModel.accentColor)
                .frame(width: 0.5)
            
            Button {
                hideKeyboard()
                viewModel.isShowBottomBar = false
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
            .padding(.leading, 8)
        }
        .foregroundColor(.black2)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(viewModel.secondaryColor)
        .transition(.move(edge: .bottom).animation(.spring(response: 0.5, dampingFraction: 0.6)))
    }
}

/// Extension for the `NoteView` class that provides methods for focusing on different notes in the note list.
extension NoteView {
    /// An enum representing the different focus targets for the note list.
    private enum FocusTarget {
        case current
        case next
        case previous
        case last
    }
    
    /// Focuses the note at the specified focus target.
    ///
    /// - Parameter target: The focus target.
    private func focusField(to target: FocusTarget) {
        // Dispatch the focus to the main thread after 0.1 seconds.
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            switch target {
            case .current:
                // Focus the current note.
                self.focusedField = viewModel.currentIndex
            case .next:
                // Focus the next note, if it exists.
                guard viewModel.currentIndex + 1 < viewModel.data.notes.count else { return }
                self.focusedField = viewModel.currentIndex + 1
            case .previous:
                // Focus the previous note, if it exists.
                guard viewModel.currentIndex > 0 else { return }
                self.focusedField = viewModel.currentIndex - 1
            case .last:
                // Focus the last note.
                self.focusedField = viewModel.data.notes.count - 1
            }
        }
    }
}

//#Preview {
//    NoteView(viewModel: .init(data: .dummy4), navigator: .init())
//}
