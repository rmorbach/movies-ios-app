//
//  Movie+Image.swift
//  Movies
//
//  Created by Rodrigo Morbach on 15/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData

extension Movie {
    var image: UIImage? {
        guard let imData = self.imageData else { return UIImage(named: "no-picture") }
        return UIImage(data: imData)
    }
}
