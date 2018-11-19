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
        return "⭐️ \(rating)"
    }

    var formattedCategorie: String {
        guard let categoriesNSSet = self.categories as? Set<Category> else {
            return ""
        }
        let categories: [Category] = [Category](categoriesNSSet)
        let sorted = categories.sorted { return $0.name! < $1.name! }

        let formatted = sorted.map { $0.name! }
        return formatted.joined(separator: "|")
    }

    var durationHours: String {
        guard let hours = self.duration?.components(separatedBy: "h").first?.trimmed() else {
            return "0"
        }
        return hours.trimmed()
    }

    var durationMinutes: String {
        guard let minutes = self.duration?.components(separatedBy: "h").last?.trimmed() else {
            return "0"
        }
        return minutes.replacingOccurrences(of: "min", with: "").trimmed()
    }

}
