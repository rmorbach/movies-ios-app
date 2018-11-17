//
//  Movie+Properties.swift
//  Movies
//
//  Created by Rodrigo Morbach on 15/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import CoreData

extension Movie {
    var formattedRating: String {
        get {
            return "⭐️ \(rating)"
        }
    }
    
    var formattedCategorie: String {
        get {
            let categories = Array<Category>(self.categories as! Set<Category>)
            let formatted = categories.map { $0.name! }
            return formatted.joined(separator: "|")
        }
    }
    
    var durationHours: String {
        get {            
            guard let hours = self.duration?.components(separatedBy: "h").first?.trimmed() else {
                return "0"
            }
            return hours.trimmed()
        }
    }
    
    var durationMinutes: String {
        get {
            guard let minutes = self.duration?.components(separatedBy: "h").last?.trimmed() else {
                return "0"
            }
            return minutes.replacingOccurrences(of: "min", with: "").trimmed()
        }
    }
    
}
