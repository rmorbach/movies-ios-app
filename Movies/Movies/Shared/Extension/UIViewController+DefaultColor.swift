//
//  UIViewController+DefaultColor.swift
//  Movies
//
//  Created by Rodrigo Morbach on 15/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

extension UIViewController {
    static var themeColor: UIColor {
        return UserSettingsManager.shared.getThemeColor()
    }
}
