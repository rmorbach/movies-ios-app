//
//  MoviesPromoTableViewCell.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MoviesPromoTableViewCell: UITableViewCell {

    static let cellIdentifier = "moviesPromoCell"
    var movies = [Movie]()
    // Mark: -  IBOutlets
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        moviesCollectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        movies = [Movie]()
    }
    
    // MARK: - Public methods
    public func prepareCell(movie: Movie) {
        if movie.items != nil && movie.items!.count > 0 {
            guard let mvs = movie.items as? Set<Movie> else { return }
            movies = Array<Movie>(mvs)
            moviesCollectionView.reloadData()
        }
    }

}

extension MoviesPromoTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemCollectionViewCell.cellIdentifier, for: indexPath) as? MovieItemCollectionViewCell {
            let movie = movies[indexPath.row]
            cell.prepareCell(movie: movie)
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
}
