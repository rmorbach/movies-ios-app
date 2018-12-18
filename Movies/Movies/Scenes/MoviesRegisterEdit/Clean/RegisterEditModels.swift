//
//  RegisterEditModels.swift
//  Movies
//
//  Created by Rodrigo Morbach on 09/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

struct CancelSelectingCategories {
    struct Request {
        
    }
    
    struct Response {
        
    }
    
    struct ViewModel {
        
    }
    
}

struct MovieToEdit {
    struct Request {}
    struct Response {
        
    }
    struct ViewModel {
        
    }
}

struct LoadCategories {
    struct Request {
        
    }
    
    struct Response {
        let loadedCategories: [Category]?
    }
    
    struct ViewModel {
        let categories: [Category]?
    }
    
}

struct AddCategory {
    struct Request {
        
    }
    struct Response {
        
    }
    struct ViewModel {
        
    }
}

struct ConfirmAddCategory {
    struct Request {
        
    }
    struct Response {
        
    }
    struct ViewModel {
        
    }
}

struct GetFormattedDuration {
    struct Request {
        let hoursText: String?
        let minutesText: String?
    }
    struct Response {
        let hoursText: String?
        let minutesText: String?
    }
    struct ViewModel {
        
    }
}

struct SaveMovie {
    struct Request {
        let title: String?
        let summary: String?
        let imageData: Data?
        let duration: String
        let categories: Set<Category>
        let rating: Double?
    }
    struct Response {
        
    }
    struct ViewModel {
        
    }
}

struct SelectPhoto {
    struct Request {
        
    }
    struct Response {
        
    }
    struct ViewModel {
        
    }
}

struct ChangeRating {
    struct Request {
        let value: Float
    }
    
    struct Response {
        let value: Float
    }
    struct ViewModel {
        let formattedValue: String
    }
}
