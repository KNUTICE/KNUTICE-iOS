//
//  MajorSelectionView76.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/26/25.
//

import KNUTICECore
import SwiftUI

struct MajorSelectionView<T>: View where T: ObservableObject & MajorCategoryProvidable {
    @EnvironmentObject private var viewModel: T
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(College.allCases, id: \.self) { college in
                    Section {
                        ForEach(college.majors, id: \.self) { major in
                            Button {
                                // FIXME: Unify ViewModel types
                                if let viewModel = viewModel as? NoticeCollectionViewModel<MajorCategory> {
                                    viewModel.category = major
                                } else if let viewModel = viewModel as? TabBarViewModel {
                                    viewModel.category = major
                                }
                                
                                dismiss()
                            } label: {
                                HStack {
                                    Text(major.localizedDescription)
                                    
                                    if let selectedCategory = viewModel.category as? MajorCategory, selectedCategory == major {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.accent2)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                    } header: {
                        Text(college.localizedDescription)
                            .font(.title3)
                            .bold()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("학과선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    MajorSelectionView<TabBarViewModel>()
        .environmentObject(TabBarViewModel(category: .computerScience))
}
