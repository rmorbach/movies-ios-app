//
//  Movie.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

struct MovieFile: Codable {
    
    let title: String
    let categories: [String]?
    let duration: String?
    let rating: Double?
    let summary: String?
    let image: String?
    let itemType: ItemType?
    let items: [MovieFile]?
    
    var formattedRating: String {
        return "⭐️ \(rating ?? 0)"
    }
    
    var formattedCategorie: String {
        guard let unwrapperCategories = categories else {
            return "Não definido"
        }
        if unwrapperCategories.count == 0 {
            return "Não definido"
        }
        var categoriesNames = "\(unwrapperCategories[0])"
        
        for categoryName in 1..<unwrapperCategories.count {
            categoriesNames.append(" | \(unwrapperCategories[categoryName])")
        }
        return categoriesNames
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case categories
        case duration
        case rating
        case summary = "description"
        case image
        case itemType = "item_type"
        case items
    }
}

enum ItemType: String, Codable {
    case movie
    case list
}
