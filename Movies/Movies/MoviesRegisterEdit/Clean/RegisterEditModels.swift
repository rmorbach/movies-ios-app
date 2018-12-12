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
        
    }
    struct Response {
        
    }
    struct ViewModel {
        
    }
}

struct SaveMovie {
    struct Request {
        
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
