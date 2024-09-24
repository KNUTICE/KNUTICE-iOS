//
//  UIDevice+Identifier.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/24/24.
//

import UIKit

extension UIDevice {
    var modelIdnetifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
