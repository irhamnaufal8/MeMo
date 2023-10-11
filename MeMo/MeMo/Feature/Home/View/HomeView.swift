//
//  HomeView.swift
//  MeMo
//
//  Created by Irham Naufal on 08/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("MeMo")
                    .font(.robotoRegular(size: 32))
                    .foregroundColor(.black1)
                
                SearchTextField(text: $viewModel.searchText)
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
                                ForEach(1...5, id: \.self) { _ in
                                    RecentNoteCard(
                                        title: "Dummy Title",
                                        description: "Dummy description"
                                    ) {}
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
                        
                        ForEach(0...10, id: \.self) { index in
                            FolderCard(
                                image: "💌",
                                notes: index,
                                title: "Dummy Title"
                            ) {}
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .overlay(alignment: .bottomTrailing, content: {
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.orange1)
                        .padding()
                        .shadow(color: .black3.opacity(0.2), radius: 15)
                }
                .scaledButtonStyle()
            })
            .background(Color.gray2.opacity(0.2))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
