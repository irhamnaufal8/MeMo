//
//  SampleAssembler.swift
//  MeMo
//
//  Created by Irham Naufal on 23/10/23.
//

import SwiftUI
import SwiftData

protocol SampleAssembler {
    func resolve(number: Int) -> DummyViewModel
}

extension SampleAssembler where Self: Assembler {
    func resolve(number: Int) -> DummyViewModel {
        return DummyViewModel(number: number)
    }
}
