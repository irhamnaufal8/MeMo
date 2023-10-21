//
//  FolderView.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI
import SwiftData

struct FolderView: View, KeyboardReadable {
    
    @State var viewModel: FolderViewModel
    @ObservedObject var navigator: AppNavigator
    
    @FocusState var focused
    
    @Environment(\.horizontalSizeClass) private var horizontalClass
    
    private var isRegularWidth: Bool {
        return horizontalClass == .regular
    }
    
    init(viewModel: FolderViewModel, navigator: AppNavigator) {
        _viewModel = State(initialValue: viewModel)
        self.navigator = navigator
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Button {
                        navigator.back()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.headline)
                            .foregroundColor(.black1)
                    }
                    .isHidden(viewModel.searchState == .select, remove: true)
                    
                    Text("\(viewModel.icon) \(viewModel.title)")
                        .font(.robotoTitle2)
                        .foregroundColor(.black1)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if viewModel.searchState == .select {
                        Button {
                            withAnimation {
                                viewModel.searchState = .initiate
                                viewModel.notesForDelete = []
                            }
                        } label: {
                            Text("Done")
                                .font(.robotoHeadline)
                                .foregroundColor(.white)
                                .padding(4)
                                .padding(.horizontal, 6)
                                .background(
                                    Capsule()
                                        .foregroundColor(viewModel.accentColor)
                                )
                        }
                    } else {
                        MenuView()
                    }
                }
                
                SearchTextField(text: $viewModel.searchText)
                    .focused($focused)
            }
            .padding()
            .background(
                viewModel.bgColor(from: viewModel.data.theme ?? "BLUE")
                    .ignoresSafeArea()
                    .shadow(color: .black3.opacity(0.1), radius: 15, y: 5)
            )
            
            ScrollView {
                switch viewModel.state {
                case .initiate:
                    NoteListView()
                case .empty:
                    EmptyStateView(
                        title: "It's still empty.. 😔",
                        desc: "Let's make a memo for today!!"
                    )
                case .notFound:
                    EmptyStateView(
                        title: "Hmm.. 🤔",
                        desc: "It looks like the memo you are looking for doesn't exist"
                    )
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.searchText)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.sortBy)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.orderBy)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottomTrailing, content: {
                Button {
                    navigator.navigateTo(.note(navigator, viewModel.createNewNote()))
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(viewModel.accentColor)
                        .padding()
                        .shadow(color: .black3.opacity(0.2), radius: 15)
                }
                .scaledButtonStyle()
                .transition(.move(edge: .trailing).animation(.spring(response: 0.5, dampingFraction: 0.6)))
                .isHidden(viewModel.searchState == .select, remove: true)
                
            })
            .background(Color.gray2.opacity(0.2))
            
            FooterView()
                .isHidden(viewModel.searchState != .select, remove: true)
        }
        .onAppear {
            viewModel.editFolderWhenFirstCreated()
            focused = viewModel.searchState == .search
        }
        .onDisappear {
            viewModel.searchState = .initiate
            viewModel.saveChanges()
            viewModel.updateModifiedDate()
        }
        .overlay {
            EditFolderView()
        }
        .memoAlert(isPresent: $viewModel.isShowAlert, property: viewModel.alert)
        .tint(viewModel.accentColor)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
    }
}

extension FolderView {
    @ViewBuilder
    func MenuView() -> some View {
        Menu {
            Button {
                withAnimation {
                    viewModel.searchState = .edit
                }
            } label: {
                Label("Edit", systemImage: "slider.horizontal.3")
            }
            
            Button {
                withAnimation {
                    viewModel.searchState = .select
                }
            } label: {
                Label("Select Notes", systemImage: "checkmark.circle")
            }
            .isHidden(viewModel.data.notes.isEmpty, remove: true)
            
            Menu {
                Picker("", selection: $viewModel.sortBy) {
                    Text("Date Edited")
                        .tag(SortBy.edited)
                    Text("Date Created")
                        .tag(SortBy.created)
                    Text("Title")
                        .tag(SortBy.title)
                }
                
                Divider()
                
                Picker("", selection: $viewModel.orderBy) {
                    Text(viewModel.sortBy == .title ? "Ascending" : "Newest First")
                        .tag(OrderBy.ascending)
                    Text(viewModel.sortBy == .title ? "Descending" : "Oldest First")
                        .tag(OrderBy.descending)
                }

            } label: {
                Label("Sort By", systemImage: "arrow.up.arrow.down")
            }
            
            Button(role: .destructive) {
                viewModel.showDeleteFolderAlert {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        navigator.back()
                    }
                }
            } label: {
                Label("Delete Folder", systemImage: "delete.left")
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black1)
                .padding(4)
        }
    }
    
    @ViewBuilder
    func FooterView() -> some View {
        HStack {
            Button {
                withAnimation {
                    viewModel.toggleSelectAll()
                }
            } label: {
                Text(viewModel.isAllSelected() ? "Unselect All" : "Select All")
                    .font(.robotoHeadline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button {
                viewModel.showDeleteNotesAlert()
            } label: {
                Text("Delete")
                    .font(.robotoHeadline)
                    .foregroundColor(viewModel.notesForDelete.isEmpty ? .gray1 : .white)
            }
            .disabled(viewModel.notesForDelete.isEmpty)
        }
        .padding()
        .background(viewModel.accentColor)
        .transition(.move(edge: .bottom).animation(.spring(response: 0.5, dampingFraction: 0.6)))
    }
    
    @ViewBuilder
    func NoteListView() -> some View {
        let columns = [
            GridItem(.flexible(minimum: 180, maximum: 900)),
            GridItem(.flexible(minimum: 180, maximum: 900)),
            GridItem(.flexible(minimum: 180, maximum: 900)),
        ]
        
        VStack(alignment: .leading, spacing: 8) {
            if isRegularWidth {
                LazyVGrid(columns: columns, spacing: 8, content: {
                    ForEach(viewModel.searchedNotes, id: \.id) { note in
                        ZStack {
                            RecentNoteCard(
                                title: note.title.orEmpty().isEmpty ? "New MeMo" : note.title ?? "New MeMo",
                                description: viewModel.description(from: note.notes),
                                date: note.modifiedAt,
                                color: viewModel.bgColor(from: note.theme.orEmpty())) {
                                    navigator.navigateTo(.note(navigator, viewModel.openNote(note)))
                                }
                                .disabled(viewModel.searchState == .select)
                            
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.black.opacity(0.3))
                                .isHidden(!viewModel.isForDelete(note))
                                .overlay {
                                    Image(systemName: viewModel.isForDelete(note) ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(viewModel.accentColor)
                                }
                                .isHidden(viewModel.searchState != .select, remove: true)
                        }
                        .onTapGesture {
                            viewModel.toggleSelection(note)
                        }
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.searchState)
                    }
                })
            } else {
                ForEach(viewModel.searchedNotes, id: \.id) { note in
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.isForDelete(note) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(viewModel.accentColor)
                            .isHidden(viewModel.searchState != .select, remove: true)
                        
                        RecentNoteCard(
                            title: note.title.orEmpty().isEmpty ? "New MeMo" : note.title.orEmpty(),
                            description: viewModel.description(from: note.notes),
                            date: note.modifiedAt,
                            color: viewModel.bgColor(from: note.theme.orEmpty())) {
                                navigator.navigateTo(.note(navigator, viewModel.openNote(note)))
                            }
                            .disabled(viewModel.searchState == .select)
                    }
                    .onTapGesture {
                        viewModel.toggleSelection(note)
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.searchState)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func EmptyStateView(title: String, desc: String) -> some View {
        VStack {
            Text(title)
                .font(.robotoTitle1)
                .foregroundColor(.black2)
            
            Text(desc)
                .font(.robotoBody)
                .foregroundColor(.black3)
        }
        .multilineTextAlignment(.center)
        .padding(32)
    }
    
    @ViewBuilder
    func EditFolderView() -> some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
                .isHidden(viewModel.searchState != .edit, remove: true)
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Folder Title")
                        .font(.robotoHeadline)
                        .foregroundColor(.black2)
                    
                    TextField("Programming Stuffs", text: $viewModel.title)
                        .font(.robotoBody)
                        .foregroundColor(.black1)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(viewModel.secondaryColor)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Folder Color")
                        .font(.robotoHeadline)
                        .foregroundColor(.black2)
                    
                    HStack(spacing: 8) {
                        ForEach(viewModel.themes, id: \.self) { theme in
                            Button {
                                withAnimation {
                                    viewModel.data.theme = theme.rawValue
                                }
                            } label: {
                                Image(systemName: viewModel.data.theme == theme.rawValue ? "checkmark.circle.fill" : "circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .foregroundColor(viewModel.accentColor(from: theme.rawValue))
                            }
                        }
                    }
                }
                
                MeMoButton(
                    text: "Done",
                    bgColor: viewModel.disableDoneButton() ? Color.gray1 : viewModel.accentColor
                ) {
                    withAnimation {
                        viewModel.searchState = .initiate
                        if viewModel.data.notes.isEmpty {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                navigator.navigateTo(.note(navigator, viewModel.createFirstNote()))
                            }
                        }
                    }
                }
                .disabled(viewModel.disableDoneButton())
            }
            .padding()
            .padding(.vertical)
            .padding(.top)
            .frame(maxWidth: 512)
            .background(Color.white)
            .cornerRadius(16)
            .offset(y: 20)
            .overlay(alignment: .top) {
                Button {
                    viewModel.isShowEmojiPicker = true
                } label: {
                    Text(viewModel.icon)
                        .font(.robotoRegular(size: 42))
                        .padding()
                        .frame(maxWidth: 80, maxHeight: 80)
                        .background(
                            Circle()
                                .strokeBorder(lineWidth: 4)
                                .foregroundColor(viewModel.accentColor)
                        )
                        .background(Color.white)
                        .clipShape(.circle)
                }
                .scaledButtonStyle()
                .offset(y: -20)
                .popover(isPresented: $viewModel.isShowEmojiPicker, arrowEdge: .bottom, content: {
                    EmojiPicker(value: $viewModel.icon) {
                        viewModel.isShowEmojiPicker = false
                    }
                    .presentationDetents([.height(280)])
                })
            }
            .padding()
            .transition(.scale.animation(.spring(response: 0.5, dampingFraction: 0.6)))
            .isHidden(viewModel.searchState != .edit, remove: true)
        }
        .onChange(of: viewModel.title) { _, newValue in
            viewModel.updateTitle(newValue)
        }
        .onChange(of: viewModel.icon) { _, newValue in
            viewModel.updateIcon(newValue)
        }
    }
}
//
//#Preview {
//    FolderView(viewModel: .init(data: .dummy), navigator: .init())
//}
