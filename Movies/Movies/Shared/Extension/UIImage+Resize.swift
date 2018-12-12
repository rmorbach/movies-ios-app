//
//  UIImage+Resize.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
extension UIImage {

    func resizedTo(maxDimension: CGFloat) -> UIImage? {
        var smallSize: CGSize = self.size
        if  smallSize.width > smallSize.height {
            if smallSize.width > maxDimension {
                let newWidth = maxDimension
                let newHeight = (smallSize.height / smallSize.width) * newWidth
                smallSize = CGSize(width: newWidth, height: newHeight)
            }
        } else if smallSize.height > maxDimension {
            let newHeight = maxDimension
            let newWidth = (smallSize.width / smallSize.height) * newHeight
            smallSize = CGSize(width: newWidth, height: newHeight)
        }

        UIGraphicsBeginImageContext(smallSize)
        self.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return smallImage
    }

}
