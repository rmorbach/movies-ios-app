//
//  RegisterEditRouter.swift
//  Movies
//
//  Created by Rodrigo Morbach on 12/12/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol RegisterEditDataPassing {
    var dataStore: RegisterEditDataStore? { get }
}

protocol RegisterEditRoutingLogic {
    
}

class RegisterEditRouter: RegisterEditRoutingLogic, RegisterEditDataPassing {
    var dataStore: RegisterEditDataStore?
}
