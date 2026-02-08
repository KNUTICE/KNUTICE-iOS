//
//  LoadableState.swift
//  KNUtility
//
//  Created by 이정훈 on 2/8/26.
//

import Foundation

public enum LoadableState<T: Equatable>: Equatable {
    case idle        // 초기 상태
    case loading     // 로딩 중
    case loaded(T)   // 성공 (데이터 포함)
    case empty       // 결과 없음
    case error       // 실패
}
