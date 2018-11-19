//
//  RatingView.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

@IBDesignable
class RatingView: CustomView {
    
    // MARK: - IBOutlets
    @IBOutlet var widthContraint: NSLayoutConstraint!
    @IBOutlet var percentView: UIView!
    @IBOutlet var ratingLabel: UILabel!
    let labelMaxWidth = 104.0
    
    public func buildRating(value: Double) {
        let newWidth = (value / 10.0) * Double(labelMaxWidth)
        self.widthContraint.constant = CGFloat(newWidth)
        self.layoutIfNeeded()
    }

}
