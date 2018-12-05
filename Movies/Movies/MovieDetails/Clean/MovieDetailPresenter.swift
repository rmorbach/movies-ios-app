//
//  MovieDetailPresenter.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import UIKit
protocol MovieDetailPresentationLogic {
    func presentMovie(response: Display.Response)
}

class MovieDetailPresenter: MovieDetailPresentationLogic {
    
    weak var viewController: MovieDetailDisplayLogic?
    
    func presentMovie(response: Display.Response) {
        
        let movie = response.movie
        
        var image: UIImage?
        if movie.image != nil {
            image = movie.image
        }
        let title = movie.title ?? "No title"
        let rating = movie.formattedRating
        let categories = movie.formattedCategorie
        let duration = movie.duration ?? "0.0"
        let summary = movie.summary ?? ""
        
        var notificationDate: Date?
        var notificationText: String?
        
        if movie.notification != nil {
            notificationDate = movie.notification?.date!
            notificationText = movie.notification!.date!.format
        }
        
        let viewModel = Display.ViewModel(coverImage: image, title: title, rating: rating, categories: categories, duration: duration, summary: summary, notificationDate: notificationDate, notificationText: notificationText)
        
        self.viewController?.displayMovie(viewModel: viewModel)
        
    }
    
}
