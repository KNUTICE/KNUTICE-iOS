//
//  UIImage+Resizing.swift
//  KNUtility
//
//  Created by 이정훈 on 2/1/26.
//

import UIKit

public extension UIImage {
    func resizedMaintainingAspectRatio(to targetSize: CGSize) -> UIImage {
        let widthRatio  = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)

        let newSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
