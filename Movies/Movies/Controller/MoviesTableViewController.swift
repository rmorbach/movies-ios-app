//
//  MoviesTableViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    var movies = [Movie]()
    var selectedMovie: Movie?
    let moviesProvider = MoviesFileDataProvider()
    
    @IBOutlet var emptyDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        loadMovies()
    }
    
    // MARK: - Private methods
    private func loadMovies() {
        moviesProvider.fetch {[weak self] error, movies in
            if error != nil {
                self?.movies = [Movie]()
            } else if movies != nil {
                self?.movies = movies!
            } else {
                self?.movies = [Movie]()
            }
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVc = segue.destination as? MovieDetailViewController {
            destVc.movie = self.selectedMovie
        }
    }
    
}

extension MoviesTableViewController: UIGestureRecognizerDelegate {}

// MARK: - Table view data source
extension MoviesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var result = 1
        self.tableView.backgroundView = nil
        if movies.count == 0 {
            self.tableView.backgroundView = self.emptyDataView
            result = 0
        }
        return result
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        if movie.itemType == ItemType.movie {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier) as? MovieTableViewCell {
                cell.prepareCell(movie: movie)
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: MoviesPromoTableViewCell.cellIdentifier) as? MoviesPromoTableViewCell {
            cell.prepareCell(movie: movie)
            return cell
        }
        
        let cell = UITableViewCell()
        cell.detailTextLabel?.text = "Teste"
        return cell
    }
}

// MARK: - Table view delegate
extension MoviesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if movie.itemType == ItemType.movie {
            self.selectedMovie = movie
            self.performSegue(withIdentifier: "movieDetailSegue", sender: nil)
        }
    }
}

