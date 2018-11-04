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
    
    private func confirmDelete(at indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let confirmActionSheet = UIAlertController(title: "Remover filme \(movie.title)?", message:nil, preferredStyle: UIAlertController.Style.actionSheet);
        let deleteAction = UIAlertAction(title: "Remover", style: UIAlertAction.Style.destructive) {[weak self] action in
            self?.movies.remove(at: indexPath.row)
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.middle)
            self?.tableView.endUpdates()
           // self?.tableView.reloadData()
        }
        let dismissAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        confirmActionSheet.addAction(deleteAction)
        confirmActionSheet.addAction(dismissAction)
        self.present(confirmActionSheet, animated: true, completion: nil)
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let movie = movies[indexPath.row]
        if movie.itemType == ItemType.movie {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Excluir") {[weak self] row, indexPath in
            self?.confirmDelete(at: indexPath)
        }
        return [deleteAction]
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

