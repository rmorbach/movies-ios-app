//
//  CustomView.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {

    @IBInspectable
    var width: CGFloat = 1.0
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 1.0)
    }
   
}
