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
    
    // MARK: IBOutlets
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

}
extension MovieItemCollectionViewCell: DataCell {
    typealias Element = Movie
    
    // MARK: - Public methods
    func prepareCell(with object: Element) {
        if object.image != nil {
            self.coverImageView.image = object.image
        }
        self.titleLabel.text = object.title
    }
}
