//
//  MovieItemCollectionViewCell.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MovieItemCollectionViewCell: UICollectionViewCell {
 
    static let cellIdentifier = "movieCell"

    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    // Mark: -  IBOutlets    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Mark: -  Public methods
    public func prepareCell(movie: Movie) {
        if movie.image != nil {
            self.coverImageView.image = UIImage(named: movie.image!)
        }
        self.titleLabel.text = movie.title
    }
    
}
