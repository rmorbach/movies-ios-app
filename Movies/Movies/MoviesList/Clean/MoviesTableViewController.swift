//
//  MoviesTableViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData

protocol MoviesListDisplayLogic: class {
    
    func displayMovies(viewModel: Fetch.ViewModel)
    func displayDeleted(viewModel: Delete.ViewModel)
    
}

class MoviesTableViewController: UITableViewController {
    
    var selectedMovie: Movie?
    
    var movies = [Movie]()
    
    var interactor: (MoviesListBusinessLogic & MoviesCoreDataProviderDelegate & MoviesListDataStore)?
    var router: MoviesListRoutingLogic?
    
    @IBOutlet var emptyDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //self.navigationController?.navigationBar.barTintColor = UIColor.blue
        loadMovies()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = UIViewController.themeColor
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Clean Setup
    
    private func setup() {
        
        let interactor = MoviesListInteractor()
        let moviesDataProvider = MoviesCoreDataProvider(with: interactor)
        let viewController = self
        viewController.interactor = interactor
        interactor.moviesWorker = moviesDataProvider
        
        let router = MoviesListRouter()
        viewController.router = router
        
        let presenter = MoviesListPresenter()
        presenter.viewController = self
        
        interactor.presenter = presenter
        router.dataStore = interactor
    }
    
    // MARK: - Private methods
    private func loadMovies() {
        interactor?.fetchMovies(request: nil)
    }
    
    private func confirmDelete(at indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let title = Localization.deleteMovieConfirm(movie.title!)
        
        let confirmActionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: Localization.delete, style: .destructive) {[weak self] action in
            let deleteRequest = Delete.Request(movie: movie)
            self?.interactor?.deleteMovie(request: deleteRequest)
        }
        let dismissAction = UIAlertAction(title: Localization.cancel, style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        confirmActionSheet.addAction(deleteAction)
        confirmActionSheet.addAction(dismissAction)
        self.present(confirmActionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "movieDetailSegue" {
            router?.routeToMovieDetails(with: segue)            
        }
    }
}

extension MoviesTableViewController: MoviesListDisplayLogic {
    
    func displayMovies(viewModel: Fetch.ViewModel) {
        self.movies = viewModel.movies ?? [Movie]()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayDeleted(viewModel: Delete.ViewModel) {
        
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
        let request = ShowDetails.Request(movie: movie)
        interactor?.showMovieDetails(request: request)
        self.performSegue(withIdentifier: "movieDetailSegue", sender: nil)
    }
}
