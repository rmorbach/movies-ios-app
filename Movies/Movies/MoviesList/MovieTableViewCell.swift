//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //static let cellIdentifier = "movieRatingCell"
    static let cellIdentifier = "movieCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        self.coverImageView.image = nil        
    }
}

extension MovieTableViewCell: DataCell {
    
    typealias Element = Movie
    
    // MARK: - Public methods
    func prepareCell(with object: Element) {
        self.titleLabel.text = object.title
        self.summaryLabel.text = object.summary
        if self.ratingLabel != nil {
            self.ratingLabel.text = object.formattedRating
        }
        self.coverImageView.image = nil
        if object.image != nil {
            self.coverImageView.image = object.image
        }
        if self.ratingView != nil {
            self.ratingView.buildRating(value: object.rating)
        }
    }
}
