//
//  MovieCategoryCollectionViewCell.swift
//  Movies
//
//  Created by Rodrigo Morbach on 15/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

import UIKit

enum State {
    case selected, unselected
}

class MovieCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let cellIdentifier = "categoryCell"
    
    var state: State = .unselected {
        didSet {
            switch state {
            case .selected:
                self.alpha = 1.0
            case .unselected:
                self.alpha = 0.2
            }
        }
    }
}
extension MovieCategoryCollectionViewCell: DataCell {
    typealias Element = Category
    // MARK: - Public methods
    func prepareCell(with object: Element) {
        self.categoryLabel.text = object.name
    }
}
