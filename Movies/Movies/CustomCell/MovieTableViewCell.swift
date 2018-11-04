//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    static let cellIdentifier = "movieCell"
    
    // Mark: -  IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.coverImageView.image = nil        
    }
    
    // Mark: -  Public methods
    
    public func prepareCell(movie: Movie) {
        self.titleLabel.text = movie.title
        self.summaryLabel.text = movie.summary
        
        self.ratingLabel.text = movie.formattedRating
        self.coverImageView.image = nil
        if movie.image != nil {
            self.coverImageView.image = UIImage(named: movie.image!)
        }
    }
    

}
