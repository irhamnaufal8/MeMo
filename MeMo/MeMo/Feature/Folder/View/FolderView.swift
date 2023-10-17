//
//  FolderView.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI

struct FolderView: View {
    
    @EnvironmentObject var viewModel: FolderViewModel
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
                    
                    Text("\(viewModel.data.icon.orEmpty()) \(viewModel.data.title)")
                        .font(.robotoTitle2)
                        .foregroundColor(.black1)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    MenuView()
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
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.searchedNotes, id: \.id) { note in
                        RecentNoteCard(
                            title: note.title,
                            description: viewModel.description(from: note.notes),
                            date: note.modifiedAt,
                            color: viewModel.bgColor(from: note.theme)) {
                                
                            }
                    }
                }
                .padding()
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.searchText)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.sortBy)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.orderBy)
            }
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
            })
            .background(Color.gray2.opacity(0.2))
        }
    }
    
    @ViewBuilder
    func MenuView() -> some View {
        Menu {
            Button {
                
            } label: {
                Label("Edit", systemImage: "slider.horizontal.3")
            }
            
            Button {
                
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
}

#Preview {
    FolderView(navigator: .init())
        .environmentObject(FolderViewModel(data: .dummy))
}
