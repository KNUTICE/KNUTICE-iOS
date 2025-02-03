//
//  ReportView.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/21/24.
//

import SwiftUI

struct ReportView: View {
    @StateObject private var viewModel: ReportViewModel
    @FocusState private var focused: Bool
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: ReportViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("• 서비스 이용 중 불편한 점이 있으시면 이곳에 문의해 주세요.")
                        
                        Text("• 상황을 구체적으로 설명해 주시면 서비스 개선에 도움이 됩니다.")
                    }
                    .foregroundStyle(.gray)
                    .font(.caption)
                    .padding(.bottom)
                    
                    LightTextView(text: $viewModel.content, isLoading: $viewModel.isLoading)
                        .focused($focused)
                        .frame(height: 400)
                        .cornerRadius(20)
                        .overlay {
                            Text("\(viewModel.content.count) / 500")
                                .foregroundStyle(.black)
                                .font(.caption)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                            
                            if viewModel.content.count == 0 {
                                Text("최소 5자, 최대 500자까지 입력 가능해요.")
                                    .font(.footnote)
                                    .padding()
                                    .foregroundStyle(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .offset(x: 6, y: 5)
                            }
                        }
                    
                    Button {
                        focused = false
                        viewModel.report(device: UIDevice.current.modelIdnetifier)
                    } label: {
                        Text("제출하기")
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                    .disabled(viewModel.content.count < 5 || viewModel.isLoading)
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("고객센터")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.light)
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
            
            if viewModel.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(.gray)
                    .offset(y: -30)
            }
        }
        .alert(isPresented: $viewModel.isShowingAlert) {
            switch viewModel.alertType {
            case .success:
                Alert(title: Text("알림"),
                      message: Text("제출 완료"),
                      dismissButton: .default(Text("확인"), action: { dismiss() }))
            case .failure:
                Alert(title: Text("알림"), message: Text("전송 실패"))
            case .textOverFlow:
                Alert(title: Text("알림"), message: Text("본문은 500자 이내로 가능합니다."))
            case .none:
                Alert(title: Text("알림"), message: Text("알 수 없는 오류"))
            }
        }
    }
}

#Preview {
    NavigationView {
        ReportView(viewModel: AppDI.shared.createReportViewModel())
    }
}
