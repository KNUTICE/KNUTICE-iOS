//
//  LightTextView.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/23/24.
//

import SwiftUI

struct LightTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isLoading: Bool
    
    private let textView = UITextView()
    
    func makeUIView(context: Context) -> UITextView {
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.tintColor = .black
        textView.font = .preferredFont(forTextStyle: .footnote)
        textView.autocorrectionType = .no    //키보드 자동완성 끄기
        textView.keyboardAppearance = .light
        textView.textContainerInset = .init(top: 20, left: 15, bottom: 20, right: 15)
        textView.delegate = context.coordinator
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        textView.inputAccessoryView = toolbar
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if isLoading {
            uiView.isEditable = false
        } else {
            uiView.isEditable = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        private var parent: LightTextView
        
        init(parent: LightTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        @objc func doneButtonTapped() {
            parent.textView.resignFirstResponder()
        }
    }
}
