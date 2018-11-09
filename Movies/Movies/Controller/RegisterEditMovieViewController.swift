//
//  RegisterEditMovieViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class RegisterEditMovieViewController: UIViewController {
    
    var editingMovie: Movie?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var movieTitleTextField: UITextField!
    @IBOutlet weak var movieCategoriesTextField: UITextField!
    @IBOutlet weak var movieRatingSlider: UISlider!
    @IBOutlet weak var currentRatingLabel: UILabel!
    @IBOutlet weak var movieSummaryTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.keyboardDismissMode = .onDrag
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObservers()
        
        movieSummaryTextView.text = ""
        let rating = editingMovie?.rating ?? 0.0
        currentRatingLabel.text = String(format: "%\(0.2)f", rating)
        self.movieRatingSlider.setValue(Float(rating), animated: true)
        
        guard let movieToEdit = editingMovie else {
            self.title = "Cadastrar filme"
            return
        }
        self.title = "Editar filme"
        buildScreen(movie: movieToEdit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removerObservers()
    }
    
    
    // MARK: - Private methods
    private func buildScreen(movie: Movie) {
        movieTitleTextField.text = movie.title
        if movie.categories != nil && movie.categories!.count > 0 {
        movieCategoriesTextField.text = movie.categories!.joined(separator: ",")
        }
        movieSummaryTextView.text = movie.summary ?? ""
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func removerObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{
            return
        }
        
        
        
        self.scrollView.contentInset.bottom = keyboardRect.height
        self.scrollView.scrollIndicatorInsets.bottom = keyboardRect.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset.bottom = 0.0
        self.scrollView.scrollIndicatorInsets.bottom = 0.0
    }
    
    // MARK: - IBAction methods
    @IBAction func back(_ sender: Any?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingChanged(_ sender: UISlider) {
        currentRatingLabel.text = String(format: "%\(0.2)f", sender.value)
    }
    
    
}
