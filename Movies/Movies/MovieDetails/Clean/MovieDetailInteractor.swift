//
//  MovieDetailInteractor.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailDataStore {
    var movie: Movie? { get set }
}

protocol MovieDetailBusinessLogic {
    func showMovie(request: Display.Request)
    func playMovieTrailer(request: VideoPlay.Request)
    func prepareToScheduleMovie(request: PrepareSchedule.Request)
    func scheduleMovie(request: Schedule.Request)
    func openSettings(request: Settings.Request)
    func cancelSchedule(request: CancelSchedule.Request)
}

class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
    var presenter: MovieDetailPresentationLogic?
    var movie: Movie?
    
    // MARK: - Private methods
    private func checkNotificationPermission(completion: @escaping (_ success: Bool) -> Void) {        NotificationManager.shared.userHasGrantedPermission(completion: { authorized in
           completion(authorized)
        })
        
        NotificationManager.shared.requestAuthorization { success in
            completion(success)
        }
    }
    
    private func scheduleMovie(with identifier: String, date: Date) {
        
        let title = Localization.notificationTitle
        let body = Localization.notificationMessage(self.movie!.title!)
        NotificationManager.shared.scheduleNotificationTriggerDate(identifier: identifier, title: title, body: body, triggerDate: date)
    }
    
    // MARK: - MovieDetailBusinessLogic methods
    func showMovie(request: Display.Request) {
        
        guard let movie = movie else { return }
        let response = Display.Response(movie: movie)
        presenter?.presentMovie(response: response)
    }
    
    func playMovieTrailer(request: VideoPlay.Request) {
        let service = TrailerService()
        service.trailerUrlFor(movie: request.movieTitle) {[weak self] previewUrlString, error in
            let success: Bool = error != nil ? false: true
            let response = VideoPlay.Response(success: success, trailerUrl: previewUrlString, errorMessage: error?.rawValue ?? "")
            
            self?.presenter?.prepareVideoToPlay(response: response)
        }
    }
    
    func prepareToScheduleMovie(request: PrepareSchedule.Request) {
        if request.state == .schedule {
            checkNotificationPermission { [weak self] success in
                var error: PrepareSchedule.ScheduleError?
                if !success {
                    error = PrepareSchedule.ScheduleError.permissionDenied
                }
                let response = PrepareSchedule.Response(error: error, state: request.state)
                self?.presenter?.prepareScheduleMovie(response: response)
            }
        } else {
            let response = PrepareSchedule.Response(error: nil, state: request.state)
            self.presenter?.prepareScheduleMovie(response: response)
        }
    }
    
    func scheduleMovie(request: Schedule.Request) {
        
        let coreDataManager = CoreDataManager.shared
        if self.movie?.notification == nil {
            self.movie?.notification = Notification(context: coreDataManager.context)
        }
        self.movie?.notification!.date = request.date
        
        let identifier = String(Date().timeIntervalSince1970)
        self.movie?.notification!.id = identifier
        try? coreDataManager.context.save()
        self.scheduleMovie(with: identifier, date: request.date)
        
        let response = Schedule.Response(success: true)
        self.presenter?.presentSchedule(response: response)
        
    }
    
    func openSettings(request: Settings.Request) {
        let response = Settings.Response(url: UIApplication.openSettingsURLString)
        presenter?.presentSettings(response: response)
    }
    
    func cancelSchedule(request: CancelSchedule.Request) {
        let response = CancelSchedule.Response()
        presenter?.presentCancelSchedule(response: response)
    }
}
