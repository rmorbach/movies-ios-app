//
//  Date+Formatter.swift
//  Movies
//
//  Created by Rodrigo Morbach on 15/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

extension Date {
    var format: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}
