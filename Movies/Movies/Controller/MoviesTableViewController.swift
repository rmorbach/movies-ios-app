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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        loadMovies()
    }
    
    // MARK: - Private methods
    private func loadMovies() {
        guard let movieSet = NSDataAsset(name: "movies")?.data else {
            return
        }
        do {
            let jsonDecoder = JSONDecoder()
            movies = try jsonDecoder.decode([Movie].self, from: movieSet)
            self.tableView.reloadData()
        } catch {
            debugPrint(error)
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

