//
//  UIImage+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIImage {

    func rotate(radians: Float) -> UIImage? {

        let newSize = CGRect(origin: CGPoint.zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral
            .size

        return UIGraphicsImageRenderer(size: newSize).image { context in

            context.cgContext.translateBy(x: newSize.width / 2, y: newSize.height / 2)
            context.cgContext.rotate(by: CGFloat(radians))

            draw(in: CGRect(x: -size.width / 2,
                            y: -size.height / 2,
                            width: size.width,
                            height: size.height))
        }
    }
}
