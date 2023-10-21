//
//  KeyboardReadable.swift
//  MeMo
//
//  Created by Irham Naufal on 18/10/23.
//

import Combine
import UIKit

/// Protocol definition for objects that want to be informed about keyboard visibility changes.
protocol KeyboardReadable {
    /// A property to access a publisher that emits boolean values to indicate keyboard visibility.
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    /// Default implementation of `keyboardPublisher` property for conforming types.

    var keyboardPublisher: AnyPublisher<Bool, Never> {
        /// Combine the notifications for keyboard will show and hide events.
        /// Map them to boolean values (true for show, false for hide).
        let showPublisher = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }

        let hidePublisher = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }

        /// Merge and debounce the notifications to prevent rapid changes.
        return Publishers.Merge(showPublisher, hidePublisher)
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    /// Function to dismiss the keyboard for the current UIResponder.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

