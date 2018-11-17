//
//  UserSettingsManager.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import UIKit

private enum UDefaultKeys {
    static let themeColor = "themeColor"
    static let autoPlay = "autoPlay"
}

enum ThemeColor: String {
    case black = "0"
    case blue = "1"
    case orange = "2"
}

class UserSettingsManager {
    
    static let shared = UserSettingsManager()

    let userDefaults = UserDefaults.standard
    
    private init() { }
    
    private func themeColorString() -> String? {
        return userDefaults.string(forKey: UDefaultKeys.themeColor)
    }
    
    // MARK - Public methods
    
    func currentThemeColor() -> ThemeColor {
        guard let colorOrder = themeColorString() else {
            return ThemeColor.black
        }
        return ThemeColor(rawValue: colorOrder) ?? ThemeColor.black
    }
    
    func getThemeColor() -> UIColor {
        
        guard let colorOrder = themeColorString() else {
            return UIColor.black
        }
        
        var themeColor = UIColor.black
        switch colorOrder {
        case ThemeColor.blue.rawValue:
            themeColor = UIColor.blue
        case ThemeColor.orange.rawValue:
            themeColor = UIColor.orange
        default:
            print("default")
        }
        
        return themeColor
    }
    
    func autoPlay() -> Bool {
        return userDefaults.bool(forKey: UDefaultKeys.autoPlay)
    }
    
    func changeTheme(with color: ThemeColor) {
        userDefaults.set(color.rawValue, forKey: UDefaultKeys.themeColor)
    }
    
    func changeAutoPlay(to autoPlay: Bool) {
        userDefaults.set(autoPlay, forKey: UDefaultKeys.autoPlay)
    }
    
    
    
    
    
}
