//
//  ReportView.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/21/24.
//

import SwiftUI

struct ReportView: View {
    @StateObject private var viewModel: ReportViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: ReportViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(.black) ]
        navBarAppearance.backgroundColor = .reportBackground
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UITextField.appearance().keyboardAppearance = .light
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("• 서비스 이용 중 불편한 점이 있으시면 이곳에 문의해주세요.")
                    
                    Text("• 상황을 구체적으로 설명해 주시면 서비스 개선에 도움이 됩니다.")
                }
                .foregroundStyle(.gray)
                .font(.footnote)
                .padding()
                
                TextField(text: $viewModel.content) {
                    Text("최소 5자, 최대 500자까지 입력 가능해요.")
                        .foregroundStyle(.gray)
                }
                .foregroundStyle(.black)
                .padding()
                .frame(height: 400, alignment: .top)
                .background(.white)
                .cornerRadius(20)
                
                Button {
                    
                } label: {
                    Text("제출하기")
                        .bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .disabled(viewModel.content.count < 5)
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("고객센터")
        .navigationBarTitleDisplayMode(.inline)
        .background(.reportBackground)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ReportView(viewModel: AppDI.shared.makeReportViewModel())
    }
}
