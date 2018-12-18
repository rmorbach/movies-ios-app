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
    func prepareVideoToPlay(response: VideoPlay.Response)
    func prepareScheduleMovie(response: PrepareSchedule.Response)
    func presentSchedule(response: Schedule.Response)
    func presentSettings(response: Settings.Response)
    func presentCancelSchedule(response: CancelSchedule.Response)
    func presentCancelNotificationSchedule(response: RemovePendingNotification.Response)
}

class MovieDetailPresenter: MovieDetailPresentationLogic {
    
    weak var viewController: MovieDetailDisplayLogic?
    
    // MARK: - MovieDetailPresentationLogic methods
    
    func prepareVideoToPlay(response: VideoPlay.Response) {
        var videoUrl: URL?
        if response.trailerUrl != nil {
            videoUrl = URL(string: response.trailerUrl!)
        }
        
        if response.success {
            let viewModel = VideoPlay.ViewModel.success(videoUrl!)
            viewController?.playMovieTrailer(viewModel: viewModel)
        } else {
            let viewModel = VideoPlay.ViewModel.error(response.errorMessage ?? "Fail")
            viewController?.playMovieTrailer(viewModel: viewModel)
        }
        
    }
    
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
        
        let viewModel = Display.ViewModel(coverImage: image, title: title,
                                          rating: rating, categories: categories,
                                          duration: duration, summary: summary,
                                          notificationDate: notificationDate, notificationText: notificationText)
        
        self.viewController?.displayMovie(viewModel: viewModel)
        
    }
    
    func prepareScheduleMovie(response: PrepareSchedule.Response) {
        if response.error != nil {
            let viewModel = PrepareSchedule.ViewModel.error(response.error!)
            viewController?.displayMovieSchedule(viewModel: viewModel)
        } else {
            let viewModel = PrepareSchedule.ViewModel.success(response.state)
            viewController?.displayMovieSchedule(viewModel: viewModel)
        }
    }
    
    func presentSchedule(response: Schedule.Response) {
        let viewModel = (response.success) ? Schedule.ViewModel.success : Schedule.ViewModel.error
        viewController?.displaySchedule(viewModel: viewModel)
    }
    
    func presentSettings(response: Settings.Response) {
        guard let url = URL(string: response.url) else { return }
        let viewModel = Settings.ViewModel.success(url)
        viewController?.displaySettings(viewModel: viewModel)        
    }
    
    func presentCancelSchedule(response: CancelSchedule.Response) {
        let title = Localization.sad
        let alertMessage = Localization.notificationDenied
        let actionOpenSettings = Localization.settings
        let actionCancel = Localization.cancel
        let viewModel = CancelSchedule.ViewModel(alertTitle: title,
                                                 alertMessage: alertMessage,
                                                 actionOpenSettings: actionOpenSettings,
                                                 actionCancel: actionCancel)
        viewController?.displayCancelSchedule(viewModel: viewModel)
    }
    
    func presentCancelNotificationSchedule(response: RemovePendingNotification.Response) {
        let viewModel = RemovePendingNotification.ViewModel()
        viewController?.displayRemovedNotificationSchedule(viewModel: viewModel)
    }
}
