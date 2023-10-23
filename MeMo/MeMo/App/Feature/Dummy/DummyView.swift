//
//  DummyView.swift
//  MeMo
//
//  Created by Irham Naufal on 23/10/23.
//

import SwiftUI

struct DummyView: View {
    
    @ObservedObject var viewModel: DummyViewModel
    @ObservedObject var navigator: MeMoNavigator
    
    var body: some View {
        VStack {
            Text("The number is \(viewModel.number)")
            
            MeMoButton(text: "Navigate to sample", bgColor: .purple1) {
                navigator.navigateTo(.sample(navigator))
            }
        }
    }
}

#Preview {
    DummyView(viewModel: AppAssembler().resolve(number: 10), navigator: .init())
}
