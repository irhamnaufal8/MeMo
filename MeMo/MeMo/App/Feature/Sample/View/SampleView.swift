//
//  SampleView.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import SwiftUI

struct SampleView: View {
    
    @ObservedObject var viewModel: SampleViewModel
    @ObservedObject var navigator: MeMoNavigator
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                
                if viewModel.notes.isEmpty {
                    Text("Data still empty")
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.notes, id: \.id) { item in
                                RecentNoteCard(
                                    title: item.title.orEmpty(),
                                    description: "Dummy message",
                                    action: {}
                                )
                            }
                        }
                    }
                }
                
                TextField("Title of your note", text: $viewModel.title)
                    .textFieldStyle(.roundedBorder)
                
                MeMoButton(text: "Try Add Note", bgColor: viewModel.title.isEmpty ? .gray1 : .purple1) {
                    viewModel.createNote()
                }
                .disabled(viewModel.title.isEmpty)
                
                MeMoButton(text: "Get Note List", bgColor: .purple1) {
                    viewModel.getAllNote()
                }
                
                MeMoButton(text: "Navigate to Dummy", bgColor: .purple1) {
                    navigator.navigateTo(.dummy(navigator, 100))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .memoAlert(isPresent: $viewModel.isSuccess, title: "Success!", primaryButton: .init(text: "Okay", bgColor: .purple1, action: { viewModel.isSuccess = false}), secondaryButton: nil)
        .memoAlert(isPresent: $viewModel.isShowError, title: "Failed!", message: viewModel.errorText, primaryButton: .init(text: "Okay", bgColor: .purple1, action: { viewModel.isShowError = false}), secondaryButton: nil)
    }
}

#Preview {
    SampleView(viewModel: AppAssembler().resolve(), navigator: .init())
}
