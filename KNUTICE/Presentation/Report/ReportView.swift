//
//  ReportView.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/21/24.
//

import ComposableArchitecture
import SwiftUI

struct ReportView: View {
    @FocusState private var focused: Bool
    @Environment(\.dismiss) private var dismiss
    @Perception.Bindable var store: StoreOf<ReportFeature>

    var body: some View {
        WithPerceptionTracking {
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
                        
                        LightTextView(
                            text: $store.content,
                            isLoading: $store.isLoading
                        )
                        .focused($focused)
                        .frame(height: 400)
                        .cornerRadius(20)
                        .overlay {
                            Text("\(store.content.count) / 500")
                                .foregroundStyle(.black)
                                .font(.caption)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                            
                            if store.content.count == 0 {
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
                            store.send(.submitButtonTapped(device: UIDevice.current.modelIdnetifier))
                        } label: {
                            Text("제출하기")
                                .bold()
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        .disabled(store.content.count < 5 || store.isLoading)
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
                
                if store.isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .tint(.gray)
                        .offset(y: -30)
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .onChange(of: store.shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ReportView(
            store: Store(initialState: ReportFeature.State()) {
                ReportFeature()
            }
        )
    }
}
