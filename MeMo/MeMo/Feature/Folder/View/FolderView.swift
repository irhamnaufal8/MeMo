//
//  FolderView.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI

struct FolderView: View {
    
    @ObservedObject var viewModel: FolderViewModel
    @ObservedObject var navigator: AppNavigator
    
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
                    .isHidden(viewModel.isSelecting, remove: viewModel.isSelecting)
                    
                    Text("\(viewModel.data.icon.orEmpty()) \(viewModel.data.title)")
                        .font(.robotoTitle2)
                        .foregroundColor(.black1)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if viewModel.isSelecting {
                        Button {
                            withAnimation {
                                viewModel.isSelecting = false
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
                        title: "Folder is still empty..",
                        desc: "Let's make a note for today!!"
                    )
                case .notFound:
                    EmptyStateView(
                        title: "Hmm..",
                        desc: "It looks like the note you are looking for doesn't exist"
                    )
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.searchText)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.sortBy)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.orderBy)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottomTrailing, content: {
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(viewModel.accentColor)
                        .padding()
                        .shadow(color: .black3.opacity(0.2), radius: 15)
                }
                .scaledButtonStyle()
                .transition(.move(edge: .trailing).animation(.spring(response: 0.5, dampingFraction: 0.6)))
                .isHidden(viewModel.isSelecting, remove: viewModel.isSelecting)
                
            })
            .background(Color.gray2.opacity(0.2))
            
            FooterView()
                .isHidden(!viewModel.isSelecting, remove: !viewModel.isSelecting)
        }
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
                    viewModel.isEditing = true
                }
            } label: {
                Label("Edit", systemImage: "slider.horizontal.3")
            }
            
            Button {
                withAnimation {
                    viewModel.isSelecting = true
                }
            } label: {
                Label("Select Notes", systemImage: "checkmark.circle")
            }
            .isHidden(viewModel.data.notes.isEmpty, remove: viewModel.data.notes.isEmpty)
            
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
                        .isHidden(!viewModel.isSelecting, remove: !viewModel.isSelecting)
                    
                    RecentNoteCard(
                        title: note.title,
                        description: viewModel.description(from: note.notes),
                        date: note.modifiedAt,
                        color: viewModel.bgColor(from: note.theme)) {
                            navigator.navigateTo(.note(navigator, .init(data: note)))
                        }
                        .disabled(viewModel.isSelecting)
                }
                .onTapGesture {
                    viewModel.toggleSelection(note)
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.isSelecting)
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

#Preview {
    FolderView(viewModel: .init(data: .dummy), navigator: .init())
}