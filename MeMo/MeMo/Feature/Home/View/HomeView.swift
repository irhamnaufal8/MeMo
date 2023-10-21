//
//  HomeView.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State var viewModel: HomeViewModel
    @ObservedObject var navigator: AppNavigator
    
    @Environment(\.horizontalSizeClass) private var horizontalClass
    
    private var isRegularWidth: Bool {
        return horizontalClass == .regular
    }
    
    init(modelContext: ModelContext, navigator: AppNavigator) {
        let viewModel = HomeViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
        self.navigator = navigator
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("MeMo")
                        .font(.robotoRegular(size: 32))
                        .foregroundColor(.black1)
                    
                    Spacer()
                    
                    Button {
                        viewModel.isShowSheet = true
                    } label: {
                        Image(systemName: "paintpalette.fill")
                            .foregroundColor(viewModel.accentColor(from: viewModel.currentTheme))
                    }
                }
                
                Button {
                    navigator.navigateTo(.global(navigator, viewModel.navigateToGlobal(state: .search)))
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.headline)
                            .foregroundColor(.black2)
                            
                        Text("Search your notes..")
                            .font(.robotoBody)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black1.opacity(0.5))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(viewModel.secondaryColor(from: viewModel.currentTheme))
                    )
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(
                Color.white
                    .ignoresSafeArea()
                    .shadow(color: .black3.opacity(0.1), radius: 15, y: 5)
            )
            
            ScrollView {
                if viewModel.folders.isEmpty && viewModel.recentNotes.isEmpty {
                    EmptyStateView(
                        title: "Let's take a memo",
                        desc: "Sshh.. You can customize the theme color 🤫"
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                } else {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Recent")
                                    .foregroundColor(.black1)
                                    .font(.robotoMedium(size: 24))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button {
                                    navigator.navigateTo(.global(navigator, viewModel.navigateToGlobal(state: .initiate)))
                                } label: {
                                    Text("See all")
                                        .foregroundColor(.black2)
                                        .font(.robotoHeadline)
                                }
                                .isHidden(viewModel.allNotes.isEmpty, remove: true)
                            }
                            .padding(.horizontal)
                            
                            if viewModel.recentNotes.isEmpty {
                                EmptyStateView(
                                    title: "You don't have any memo",
                                    desc: "Let's create your first memo 🤩"
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(viewModel.recentNotes, id: \.id) { note in
                                            RecentNoteCard(
                                                title: note.title.orEmpty().isEmpty ? "New MeMo" : note.title.orEmpty(),
                                                description: viewModel.description(from: note.notes),
                                                color: viewModel.bgColor(from: note.theme.orEmpty())
                                            ) {
                                                navigator.navigateTo(.note(navigator, viewModel.openRecentNote(note)))
                                            }
                                            .frame(width: 200)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Folder")
                                    .foregroundColor(.black1)
                                    .font(.robotoMedium(size: 24))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button {
                                    navigator.navigateTo(.folder(navigator, viewModel.createNewFolder()))
                                } label: {
                                    Image(systemName: "plus.app")
                                        .foregroundColor(.black2)
                                        .font(.system(size: 20))
                                }
                            }
                            
                            if viewModel.folders.isEmpty {
                                EmptyStateView(
                                    title: "You don't have any folder",
                                    desc: "Let's create your first folder 🎨"
                                )
                                .frame(maxWidth: .infinity)
                            } else {
                                FoldersView()
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                    .padding(.top)
                }
            }
            .overlay(alignment: .bottomTrailing, content: {
                FloatingButton()
            })
            .background(viewModel.secondaryColor(from: viewModel.currentTheme).opacity(0.1))
        }
        .onAppear {
            viewModel.getAllNotes()
        }
        .onDisappear {
            viewModel.saveChanges()
        }
        .tint(viewModel.accentColor(from: viewModel.currentTheme))
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $viewModel.isShowSheet) {
            ThemeSheet()
                .presentationDetents([.fraction(0.8)])
        }
    }
}

extension HomeView {
    
    @ViewBuilder
    func FoldersView() -> some View {
        let columns = [
            GridItem(.flexible(minimum: 180, maximum: 900)),
            GridItem(.flexible(minimum: 180, maximum: 900)),
            GridItem(.flexible(minimum: 180, maximum: 900)),
        ]
        
        if isRegularWidth {
            LazyVGrid(columns: columns, spacing: 8, content: {
                ForEach(viewModel.folders, id: \.id) { folder in
                    FolderCard(
                        image: folder.icon.orEmpty(),
                        notes: viewModel.countNotes(from: folder),
                        title: folder.title.orEmpty(),
                        color: viewModel.bgColor(from: folder.theme.orEmpty())
                    ) {
                        navigator.navigateTo(.folder(navigator, viewModel.openFolder(folder)))
                    }
                }
            })
        } else {
            ForEach(viewModel.folders, id: \.id) { folder in
                FolderCard(
                    image: folder.icon.orEmpty(),
                    notes: viewModel.countNotes(from: folder),
                    title: folder.title.orEmpty(),
                    color: viewModel.bgColor(from: folder.theme.orEmpty())
                ) {
                    navigator.navigateTo(.folder(navigator, viewModel.openFolder(folder)))
                }
            }
        }
    }
    
    @ViewBuilder
    func FloatingButton() -> some View {
        if viewModel.recentNotes.isEmpty && viewModel.folders.isEmpty {
            Menu {
                Button {
                    navigator.navigateTo(.note(navigator, viewModel.createNewNote()))
                } label: {
                    Label("Memo", systemImage: "doc.text")
                }
                
                Button {
                    navigator.navigateTo(.folder(navigator, viewModel.createNewFolder()))
                } label: {
                    Label("Folder", systemImage: "folder")
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(viewModel.accentColor(from: viewModel.currentTheme))
                    .padding()
                    .shadow(color: .black3.opacity(0.2), radius: 15)
            }

        } else {
            Button {
                navigator.navigateTo(.note(navigator, viewModel.createNewNote()))
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(viewModel.accentColor(from: viewModel.currentTheme))
                    .padding()
                    .shadow(color: .black3.opacity(0.2), radius: 15)
            }
            .scaledButtonStyle()
        }
    }
    
    @ViewBuilder
    func ThemeSheet() -> some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Theme Color")
                        .font(.robotoTitle1)
                        .foregroundColor(.black1)
                    
                    Text("Select your favorite theme color")
                        .font(.robotoBody)
                        .foregroundColor(.black3)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Button {
                    viewModel.isShowSheet = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.black3.opacity(0.5))
                        .font(.title2)
                }
            }
            .padding([.top, .horizontal])
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(viewModel.themes, id: \.self) { theme in
                        Button {
                            viewModel.selectTheme(theme.rawValue)
                        } label: {
                            HStack(spacing: 12) {
                                viewModel.appIcon(from: theme.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(12)
                                
                                VStack(alignment: .leading) {
                                    Text(theme.rawValue)
                                        .font(.robotoHeadline)
                                        .foregroundColor(.black2)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(viewModel.accentColor(from: theme.rawValue))
                                    .isHidden(viewModel.currentTheme != theme.rawValue, remove: viewModel.currentTheme != theme.rawValue)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(viewModel.bgColor(from: theme.rawValue))
                            )
                            .overlay {
                                if viewModel.currentTheme == theme.rawValue {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(viewModel.accentColor(from: theme.rawValue))
                                }
                            }
                        }
                        .scaledButtonStyle()
                    }
                }
                .padding()
            }
        }
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
//    HomeView(
//        modelContext: .init(), navigator: .init())
//}
