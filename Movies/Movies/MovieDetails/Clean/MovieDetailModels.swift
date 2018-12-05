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

struct VideoPlay {
    struct Request {
        let movieTitle: String
    }
    
    struct Response {
        let success: Bool
        let trailerUrl: String?
        let errorMessage: String?
    }
    
    struct ViewModel {
        let success: Bool
        let trailerUrl: URL?
        let errorMessage: String?
    }
}

struct PrepareSchedule {
    
    enum ScheduleError {
        case permissionDenied
    }
    
    enum ScheduleState {
        case cancel, schedule
    }
    
    struct Request {
        let state: ScheduleState
    }
    
    struct Response {
        let error: ScheduleError?
        let state: ScheduleState
    }
    
    struct ViewModel {
        let error: ScheduleError?
        let state: ScheduleState
    }
}

struct Schedule {
    struct Request {
        let date: Date
    }
    
    struct Response {
        let success: Bool
    }
    
    struct ViewModel {
        let success: Bool
    }
}

struct Settings {
    struct Request { }
    
    struct Response {
        let url: String
    }
    
    struct ViewModel {
        let url: URL
    }
}

struct CancelSchedule {
    struct Request { }
    
    struct Response {
        
    }
    
    struct ViewModel {
        let alertTitle: String
        let alertMessage: String
        let actionOpenSettings: String
        let actionCancel: String        
    }
}
