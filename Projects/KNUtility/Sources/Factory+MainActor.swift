//
//  Factory+MainActor.swift
//  KNUtility
//
//  Created by 이정훈 on 1/21/26.
//

import Factory

public extension Factory {
    @MainActor
    static func mainActor(
        _ container: ManagedContainer,
        key: StaticString = #function,
        _ factory: @escaping @MainActor () -> T
    ) -> Factory<T> where T: Sendable {
        Factory(container, key: key) {
            MainActor.assumeIsolated {
                factory()
            }
        }
    }
}
