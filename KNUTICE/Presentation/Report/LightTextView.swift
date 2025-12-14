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
        private let characterLimit = 500
        
        init(parent: LightTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // 현재 텍스트 가져오기
            let currentText = textView.text ?? ""
            
            // 변경하려는 범위(NSRange)를 Swift의 Range로 변환
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // 변경 후의 텍스트가 어떻게 될지 미리 계산
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            
            // 계산된 텍스트가 제한 글자 수 이하일 때만 true 반환 (입력 허용)
            return updatedText.count <= characterLimit
        }
        
        @objc func doneButtonTapped() {
            parent.textView.resignFirstResponder()
        }
    }
}
