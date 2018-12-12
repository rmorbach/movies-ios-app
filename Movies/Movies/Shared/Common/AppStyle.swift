//
//  AppStyle.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

extension UIFont {
    static let title = UIFont.boldSystemFont(ofSize: 28)
    static let body = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
}

enum Color {
    static let defaultFontColor = UIColor.white
}

enum Margin {
    static let defaultMargin: CGFloat = 16
    static let horizontal: CGFloat = 24
    static let verticalLarge: CGFloat = 24
}
