//
//  View+isHidden.swift
//  MeMo
//
//  Created by Irham Naufal on 17/10/23.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
