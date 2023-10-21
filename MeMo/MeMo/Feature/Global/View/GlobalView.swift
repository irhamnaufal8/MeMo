//
//  GlobalView.swift
//  MeMo
//
//  Created by Irham Naufal on 21/10/23.
//

import SwiftUI
import SwiftData

struct GlobalView: View, KeyboardReadable {
    
    @State var viewModel: GlobalViewModel
    @ObservedObject var navigator: AppNavigator
    
    @FocusState var focused
    
    init(viewModel: GlobalViewModel, navigator: AppNavigator) {
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
                    
                    Text("All Your Notes")
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
                viewModel.bgColor(from: viewModel.theme)
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
            focused = viewModel.searchState == .search
        }
        .onDisappear {
            viewModel.searchState = .initiate
            viewModel.saveChanges()
        }
        .tint(viewModel.accentColor)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
    }
}

extension GlobalView {
    @ViewBuilder
    func MenuView() -> some View {
        Menu {
            Button {
                withAnimation {
                    viewModel.searchState = .select
                }
            } label: {
                Label("Select Notes", systemImage: "checkmark.circle")
            }
            
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
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black1)
                .padding(4)
        }
        .isHidden(viewModel.data.isEmpty, remove: true)
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
                viewModel.deleteNotes()
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
        VStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.searchedNotes, id: \.id) { note in
                HStack(spacing: 12) {
                    Image(systemName: viewModel.isForDelete(note) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(viewModel.accentColor)
                        .isHidden(viewModel.searchState != .select, remove: true)
                    
                    RecentNoteCard(
                        title: note.title.orEmpty().isEmpty ? "New MeMo" : note.title ?? "New MeMo",
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
}


//#Preview {
//    GlobalView(viewModel: .init(modelContext: , theme: "PURPLE"), navigator: .init())
//}
