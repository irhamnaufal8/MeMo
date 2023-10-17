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
                Text("MeMo")
                    .font(.robotoRegular(size: 32))
                    .foregroundColor(.black1)
                
                SearchTextField(text: $viewModel.searchText, bgColor: .purple2)
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
                        .foregroundColor(.purple1)
                        .padding()
                        .shadow(color: .black3.opacity(0.2), radius: 15)
                }
                .scaledButtonStyle()
            })
            .background(Color.gray2.opacity(0.2))
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView(viewModel: .init(), navigator: .init())
}
