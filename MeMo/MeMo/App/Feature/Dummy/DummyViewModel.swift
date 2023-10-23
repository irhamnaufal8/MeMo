//
//  DummyViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 23/10/23.
//

import Foundation

final class DummyViewModel: ObservableObject {
    @Published var number: Int
    
    init(number: Int) {
        self.number = number
    }
}
