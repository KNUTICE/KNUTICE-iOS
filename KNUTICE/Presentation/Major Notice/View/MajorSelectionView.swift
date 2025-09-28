//
//  MajorSelectionView76.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/26/25.
//

import KNUTICECore
import SwiftUI

struct MajorSelectionView: View {
    @EnvironmentObject private var viewModel: MajorNoticeCollectionViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(College.allCases, id: \.self) { college in
                    Section {
                        ForEach(college.majors, id: \.self) { major in
                            Button {
                                viewModel.selectedMajor = major
                                dismiss()
                            } label: {
                                HStack {
                                    Text(major.localizedDescription)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.accent2)
                                        .opacity(viewModel.selectedMajor == major ? 1 : 0)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
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
    MajorSelectionView()
        .environmentObject(MajorNoticeCollectionViewModel())
}
