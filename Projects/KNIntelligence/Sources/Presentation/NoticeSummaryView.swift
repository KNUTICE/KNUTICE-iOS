//
//  NoticeSummaryView.swift
//  KNIntelligence
//
//  Created by 이정훈 on 1/30/26.
//

import KNDesignSystem
import KNMarkdown
import SwiftUI

public struct NoticeSummaryView: View {
    private let viewModel: NoticeSummaryViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    public init(viewModel: NoticeSummaryViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Label {
                    Text("AI Summarization")
                        .bold()
                } icon: {
                    KNDesignSystemAsset.knuticeaiLogo.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                .padding(.leading, 10)
                
                VStack {
                    ForEach(viewModel.nodes) { node in
                        Group {
                            switch node {
                            case let .heading(content, level):
                                Text(.init(content))
                                    .bold()
                                    .font(level == 3 ? .title : level == 2 ? .title2 : .title3)
                                    .padding(.top)
                                
                            case let .paragraph(content):
                                Text(.init(content))
                                
                            case let .listItem(content):
                                HStack(alignment: .firstTextBaseline, spacing: 3) {
                                    Text("•")
                                    Text(.init(content))
                                }
                                
                            case let .table(headers, rows):
                                MarkdownTableView(headers: headers, rows: rows)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(KNDesignSystemAsset.gray2.swiftUIColor)
                .cornerRadius(10)
                .padding(.trailing)
                .padding(.leading, 30)
                
                Text("Gemini가 답변을 생성하는 과정에서 실수가 있을 수 있습니다.")
                    .font(.caption)
                    .padding(.leading, 30)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.gray)
            }
            .opacity(viewModel.nodes.isEmpty ? 0 : 1)
        }
        .scrollIndicators(.hidden)
        .background(colorScheme == .light ? .white : .black)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .presentationDragIndicator(.visible)
        .task {
            await viewModel.fetch()
        }
    }
}

#Preview {
    NoticeSummaryView(viewModel: NoticeSummaryViewModel(nttId: 1085082))
}
