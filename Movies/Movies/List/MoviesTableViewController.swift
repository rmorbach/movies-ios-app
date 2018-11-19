//
//  MoviesTableViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {
    
    var selectedMovie: Movie?
    
    var moviesDataProvider: MoviesCoreDataProvider?
    
    var movies = [Movie]()
    
    @IBOutlet var emptyDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //self.navigationController?.navigationBar.barTintColor = UIColor.blue
        moviesDataProvider = MoviesCoreDataProvider(with: self)
        loadMovies()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = UIViewController.themeColor
    }
    
    // MARK: - Private methods
    private func loadMovies() {
        
        moviesDataProvider?.fetch { [weak self] error, loadedMovies in
            if error == nil {
                self?.movies = loadedMovies ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                debugPrint("Error fetching movies")
            }
        }
    
    }
    
    private func confirmDelete(at indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let title = "Remover filme \(movie.title!)?"
        
        let confirmActionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Remover", style: .destructive) {[weak self] action in
            _ = self?.moviesDataProvider?.delete(object: movie)
        }
        let dismissAction = UIAlertAction(title: "Cancelar", style: .default) { action in
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
        
        self.tableView.backgroundView = nil
        let counter = movies.count
        
        if counter == 0 {
            self.tableView.backgroundView = self.emptyDataView
            return 0
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = movies[indexPath.row]
        
        let cll = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier)
        if let cell = cll as? MovieTableViewCell {
            cell.prepareCell(with: movie)
            return cell
        }
        
        let cell = UITableViewCell()
        cell.detailTextLabel?.text = "Teste"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt idxP: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") {[weak self] row, indexPath in
            self?.confirmDelete(at: indexPath)
        }
        return [deleteAction]
    }
    
}

// MARK: - Table view delegate
extension MoviesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        self.selectedMovie = movie
        self.performSegue(withIdentifier: "movieDetailSegue", sender: nil)
    }
}

extension MoviesTableViewController: MoviesCoreDataProviderDelegate {
    func dataDidChange() {
        self.loadMovies()
    }
}
