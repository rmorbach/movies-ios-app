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
        get {
            return "⭐️ \(rating ?? 0)"
        }
    }
    
    var formattedCategorie: String {
        get {
            if categories == nil || categories!.count <= 0 {
                return "Não definido"
            }
            var s = "\(categories![0])"
            for i in 1..<categories!.count {
                s.append(" | \(categories![i])")
            }
            return s
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title;
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
    case movie = "movie"
    case list = "list"
}
