//
//  MovieDetailModel.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

struct Display {
    struct Request {
        let movie: Movie?
    }
    struct Response {
        let movie: Movie
    }
    struct ViewModel {
        let coverImage: UIImage?
        let title: String
        let rating: String
        let categories: String
        let duration: String
        let summary: String
        let notificationDate: Date?
        let notificationText: String?
        
        init(coverImage: UIImage?, title: String, rating: String, categories: String, duration: String, summary: String, notificationDate: Date? = nil, notificationText: String? = nil) {
            self.coverImage = coverImage
            self.title = title
            self.rating = rating
            self.duration = duration
            self.summary = summary
            self.categories = categories
            self.notificationDate = notificationDate
            self.notificationText = notificationText
        }
        
    }
}
