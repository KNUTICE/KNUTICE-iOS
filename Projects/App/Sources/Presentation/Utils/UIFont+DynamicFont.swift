//
//  UIFont+DynamicFont.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/5/24.
//

import UIKit

extension UIFont {
    //dynamic font는 유지한채 weight 적용
    static func font(for style: TextStyle, weight: Weight) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        let metrics = UIFontMetrics(forTextStyle: style)
        
        return metrics.scaledFont(for: font)
    }
}
