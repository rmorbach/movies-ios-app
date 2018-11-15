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
    
    var fetchedResultController: NSFetchedResultsController<Movie>?
    
    @IBOutlet var emptyDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        loadMovies()
    }
    
    // MARK: - Private methods
    private func loadMovies() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortTitleDescriptor = NSSortDescriptor(keyPath: \Movie.title, ascending: true)
        
        fetchRequest.sortDescriptors = [sortTitleDescriptor];
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController?.delegate = self;
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print(error)
        }
    }
    
    private func confirmDelete(at indexPath: IndexPath) {
        guard let movie = self.fetchedResultController?.object(at: indexPath) else {
            return
        }
        let confirmActionSheet = UIAlertController(title: "Remover filme \(movie.title)?", message:nil, preferredStyle: UIAlertController.Style.actionSheet);
        let deleteAction = UIAlertAction(title: "Remover", style: UIAlertAction.Style.destructive) {[weak self] action in
            self?.context.delete(movie)
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.middle)
            self?.tableView.endUpdates()
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
        self.tableView.backgroundView = nil
        guard let counter = fetchedResultController?.fetchedObjects?.count else {
            self.tableView.backgroundView = self.emptyDataView
            return 0
        }
        if counter == 0 {
            self.tableView.backgroundView = self.emptyDataView
            return 0
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let movie = self.fetchedResultController?.object(at: indexPath) else {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier) as? MovieTableViewCell {
            cell.prepareCell(movie: movie)
            return cell
        }
        
        let cell = UITableViewCell()
        cell.detailTextLabel?.text = "Teste"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
        guard let movie = self.fetchedResultController?.object(at: indexPath) else { return }
        self.selectedMovie = movie
        self.performSegue(withIdentifier: "movieDetailSegue", sender: nil)
    }
}

extension MoviesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.tableView.reloadData()
    }
}

