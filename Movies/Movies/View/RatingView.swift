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
    
    // MARK - IBOutlets
    @IBOutlet var widthContraint: NSLayoutConstraint!
    @IBOutlet var percentView: UIView!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var ratingLabel: UILabel!
    
    public func buildRating(value: Double) {
        let percentValue = 1 - (value * 1.0) / 10.0
        let maxWidth = (self.ratingLabel.frame.size.width > self.ratingLabel.frame.size.height) ? self.ratingLabel.frame.size.width : self.ratingLabel.frame.size.height
        self.trailingConstraint.constant = maxWidth * CGFloat(percentValue)
        self.layoutIfNeeded()
    }
    
    
}
