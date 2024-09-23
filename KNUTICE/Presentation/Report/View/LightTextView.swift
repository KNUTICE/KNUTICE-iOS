//
//  LightTextView.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/23/24.
//

import SwiftUI

struct LightTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.tintColor = .black
        textView.font = .preferredFont(forTextStyle: .footnote)
        textView.autocorrectionType = .no    //키보드 자동완성 끄기
        textView.keyboardAppearance = .light
        textView.textContainerInset = .init(top: 20, left: 15, bottom: 20, right: 15)
        textView.delegate = context.coordinator
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {}
    
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
    }
}
