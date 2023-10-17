//
//  HomeView.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var navigator: AppNavigator
    
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
                
                SearchTextField(text: $viewModel.searchText, bgColor: viewModel.secondaryColor(from: viewModel.currentTheme))
            }
            .padding()
            .background(
                Color.white
                    .ignoresSafeArea()
                    .shadow(color: .black3.opacity(0.1), radius: 15, y: 5)
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Recent")
                                .foregroundColor(.black1)
                                .font(.robotoMedium(size: 24))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button {
                                
                            } label: {
                                Text("See all")
                                    .foregroundColor(.black2)
                                    .font(.robotoHeadline)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.recentNotes, id: \.id) { note in
                                    RecentNoteCard(
                                        title: note.title,
                                        description: viewModel.description(from: note.notes),
                                        color: viewModel.bgColor(from: note.theme)
                                    ) {
                                        navigator.navigateTo(.note(navigator, .init(data: note)))
                                    }
                                    .frame(width: 200)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Folder")
                                .foregroundColor(.black1)
                                .font(.robotoMedium(size: 24))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "plus.app")
                                    .foregroundColor(.black2)
                                    .font(.system(size: 20))
                            }
                        }
                        
                        ForEach(viewModel.folders, id: \.id) { folder in
                            FolderCard(
                                image: folder.icon.orEmpty(),
                                notes: viewModel.countNotes(from: folder),
                                title: folder.title,
                                color: viewModel.bgColor(from: folder.theme.orEmpty())
                            ) {
                                navigator.navigateTo(.folder(navigator, .init(data: folder)))
                            }
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
                .padding(.top)
            }
            .overlay(alignment: .bottomTrailing, content: {
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(viewModel.accentColor(from: viewModel.currentTheme))
                        .padding()
                        .shadow(color: .black3.opacity(0.2), radius: 15)
                }
                .scaledButtonStyle()
            })
            .background(Color.gray2.opacity(0.2))
        }
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
}

#Preview {
    HomeView(viewModel: .init(), navigator: .init())
}
