//
//  MultilineTextField.swift
//  MeMo
//
//  Created by Irham Naufal on 11/10/23.
//

import SwiftUI
import UIKit

/// A custom text view wrapper that provides support for multiline editing and dynamic height.
private struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = CustomTextView
    
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var font: UIFont?
    var onDone: (() -> Void)?
    var onStartEditing: (() -> Void)?
    var onEndEditing: (() -> Void)?
    var onBackspace: ((Bool) -> Void)?
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> CustomTextView {
        let textField = CustomTextView()
        textField.delegate = context.coordinator
        
        textField.isEditable = true
        textField.font = self.font
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if onDone != nil {
            textField.returnKeyType = .done
        }
        textField.textContainer.lineFragmentPadding = 0
        textField.textContainerInset.top = 0
        textField.textContainerInset.bottom = 0
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
    
    func updateUIView(_ uiView: CustomTextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
        uiView.onBackspace = self.onBackspace
    }
    
    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(
            text: $text,
            height: $calculatedHeight,
            onDone: onDone,
            onStartEditing: onStartEditing,
            onEndEditing: onEndEditing
        )
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        var onStartEditing: (() -> Void)?
        var onEndEditing: (() -> Void)?
        
        init(
            text: Binding<String>,
            height: Binding<CGFloat>,
            onDone: (() -> Void)? = nil,
            onStartEditing: (() -> Void)? = nil,
            onEndEditing: (() -> Void)? = nil
        ) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
            self.onStartEditing = onStartEditing
            self.onEndEditing = onEndEditing
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            
            UITextViewWrapper.recalculateHeight(view: uiView, result: self.calculatedHeight)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            guard let onStartEditing = onStartEditing else {
                return
            }
            
            onStartEditing()
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            guard let onEndEditing = onEndEditing else {
                return
            }
            
            onEndEditing()
        }
    }
    
    final class CustomTextView: UITextView {
        var onBackspace: ((Bool) -> Void)?
        
        override init(frame: CGRect, textContainer: NSTextContainer?) {
            self.onBackspace = nil
            super.init(frame: frame, textContainer: textContainer)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func deleteBackward() {
            onBackspace?(text?.isEmpty == true)
            super.deleteBackward()
        }
    }
}

/// A custom text view that allows for multiline editing.
struct MultilineTextField: View {
    /// The placeholder text for the text view.
    private var placeholder: String
    
    /// The binding to the text in the text view.
    @Binding private var text: String
    
    /// The font for the text view.
    private var font: UIFont?
    
    /// The callback to be executed when the user commits to the text view.
    private var onCommit: (() -> Void)?
    
    /// The callback to be executed when the user starts editing the text view.
    private var onEdit: (() -> Void)?
    
    /// The callback to be executed when the user finishes editing the text view.
    private var onDoneEdit: (() -> Void)?
    
    /// The callback to be executed when the user presses the backspace key.
    var onBackspace: ((Bool) -> Void)?
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text }) { self.text = $0 }
    }
    
    @State private var dynamicHeight: CGFloat = 60
    @State private var isShowingPlaceholder = true
    
    /// Initializes a new `MultilineTextField`.
    init(
        _ placeholder: String = "Your text here..",
        text: Binding<String>,
        font: UIFont? = .robotoBody,
        onCommit: (() -> Void)? = nil,
        onEdit: (() -> Void)? = nil,
        onDoneEdit: (() -> Void)? = nil,
        onBackspace: ((Bool) -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self.font = font
        self.onEdit = onEdit
        self.onDoneEdit = onDoneEdit
        self.onBackspace = onBackspace
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if isShowingPlaceholder && text.isEmpty {
                Text(placeholder)
                    .font(placeholderFont(from: self.font))
                    .foregroundColor(.black3)
                    .padding(.top, 0.05)
            }
            
            UITextViewWrapper(
                text: self.internalText,
                calculatedHeight: $dynamicHeight,
                font: self.font,
                onDone: onCommit,
                onStartEditing: {
                    onEdit?()
                    isShowingPlaceholder = false
                },
                onEndEditing: {
                    onDoneEdit?()
                    isShowingPlaceholder = internalText.wrappedValue.isEmpty
                },
                onBackspace: onBackspace
            )
            .frame(minHeight: abs(dynamicHeight) >= 200 ? abs(200) : abs(dynamicHeight), maxHeight: abs(dynamicHeight) >= 200 ? abs(200) : abs(dynamicHeight))
            .contentShape(Rectangle())
            .disableAutocorrection(true)
        }
    }
    
    /// Convert UIFont into SwiftUI Font
    private func placeholderFont(from uiFont: UIFont?) -> Font {
        switch uiFont {
        case UIFont.robotoHeadline:
            return .robotoHeadline
        case UIFont.robotoTitle1:
            return .robotoTitle1
        case UIFont.robotoTitle2:
            return .robotoTitle2
        case UIFont.robotoTitle3:
            return .robotoTitle3
        case UIFont.robotoCaption:
            return .robotoCaption
        default:
            return .robotoBody
        }
    }
}
