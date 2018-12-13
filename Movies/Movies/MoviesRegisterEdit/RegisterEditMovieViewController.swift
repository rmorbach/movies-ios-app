//
//  RegisterEditMovieViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData

protocol RegisterEditDisplayLogic: class {
    func displayCategories(viewModel: LoadCategories.ViewModel)
    func displaySavedMovie(viewModel: SaveMovie.ViewModel)
    func displayChangedRating(viewModel: ChangeRating.ViewModel)
}

class RegisterEditMovieViewController: UIViewController {
    
    var editingMovie: Movie?
    //var selectedCategories = Set<Category>()
    var pictureChanged = false
    var categoriesDataProvider: CategoriesCoreDataProvider?
    //var categories = [Category]()
    let categoriesDataSource = CategoriesDataSource()
    
    var interactor: (RegisterEditBusinessLogic & RegisterEditDataStore)?
    
    var router: (RegisterEditRoutingLogic & RegisterEditDataPassing)?
    
    lazy var hourPickerView: UIPickerView = {
        let pkv = UIPickerView()
        pkv.delegate = self
        pkv.dataSource = self
        return pkv
    }()
    
    lazy var minutesPickerView: UIPickerView = {
        let pkv = UIPickerView()
        pkv.delegate = self
        pkv.dataSource = self
        return pkv
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var durationMinutesTextField: UITextField!
    @IBOutlet weak var movieTitleTextField: UITextField!
    @IBOutlet weak var movieCategoriesTextField: UITextField!
    @IBOutlet weak var movieRatingSlider: UISlider!
    @IBOutlet weak var currentRatingLabel: UILabel!
    @IBOutlet weak var movieSummaryTextView: UITextView!
    @IBOutlet weak var durationHoursTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.keyboardDismissMode = .onDrag
        self.categoriesCollectionView.delegate = self.categoriesDataSource
        self.categoriesCollectionView.dataSource = self.categoriesDataSource
        self.categoriesDataSource.delegate = self
        
        editingMovie = interactor?.movie
        
        if editingMovie != nil && editingMovie?.categories != nil {
            if let setCategories = editingMovie!.categories as? Set<Category> {
                self.categoriesDataSource.selectedCategories = setCategories
            }
        }
        categoriesDataProvider = CategoriesCoreDataProvider(delegate: self)
        prepareTextFields()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIViewController.themeColor
        self.addObservers()
        
        movieSummaryTextView.text = ""
        let rating = editingMovie?.rating ?? 0.0
        currentRatingLabel.text = String(format: "%\(0.2)f", rating)
        self.movieRatingSlider.setValue(Float(rating), animated: true)
        
        guard let movieToEdit = editingMovie else {
            self.title = Localization.addMovieTitle
            return
        }
        self.title = Localization.editMovieTitle
        buildScreen(movie: movieToEdit)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removerObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        let viewController = self
        let interactor = RegisterEditInteractor()
        let presenter = RegisterEditPresenter()
        presenter.viewController = self
        interactor.presenter = presenter
        viewController.interactor = interactor
        let categoriesDataProvider = CategoriesCoreDataProvider(delegate: interactor)
        interactor.worker = categoriesDataProvider
        
        let router = RegisterEditRouter()
        viewController.router = router
        viewController.interactor = interactor
        router.dataStore = interactor
        
    }
    
    private func prepareTextFields() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let okButton = UIBarButtonItem()
        okButton.style = .done
        okButton.title = Localization.ok
        okButton.target = self
        okButton.action = #selector(doneSelecting)
        
        let cancelButton = UIBarButtonItem()
        cancelButton.title = Localization.cancel
        cancelButton.style = .plain
        cancelButton.target = self
        cancelButton.action = #selector(cancelSelecting)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, okButton]
        self.durationHoursTextField.inputView = hourPickerView
        self.durationHoursTextField.inputAccessoryView = toolbar
        
        self.durationMinutesTextField.inputView = minutesPickerView
        self.durationMinutesTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneSelecting() {
        self.durationHoursTextField.text = "\(hourPickerView.selectedRow(inComponent: 0))"
        self.durationMinutesTextField.text = "\(minutesPickerView.selectedRow(inComponent: 0))"
        cancelSelecting()
    }
    
    @objc func cancelSelecting() {
        view.endEditing(true)
    }
    
    private func buildScreen(movie: Movie) {
        movieTitleTextField.text = movie.title
        coverImageView.image = movie.image
        movieSummaryTextView.text = movie.summary ?? ""
        durationHoursTextField.text = movie.durationHours
        durationMinutesTextField.text = movie.durationMinutes
    }
    
    private func addObservers() {
        let dntfc = NotificationCenter.default
        let keyboardWillShowS = #selector(keyboardWillShow)
        let keyboardWillHideS = #selector(keyboardWillHide)
        
        let keyboardWillShowN = UIResponder.keyboardWillShowNotification
        let keyboardWillHideN = UIResponder.keyboardWillHideNotification
        dntfc.addObserver(self, selector: keyboardWillShowS, name: keyboardWillShowN, object: nil)
        dntfc.addObserver(self, selector: keyboardWillHideS, name: keyboardWillHideN, object: nil)
        
    }
    
    func removerObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        self.scrollView.contentInset.bottom = keyboardRect.height
        self.scrollView.scrollIndicatorInsets.bottom = keyboardRect.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset.bottom = 0.0
        self.scrollView.scrollIndicatorInsets.bottom = 0.0
    }
    
    private func loadCategories() {
        self.interactor?.loadCategories(request: nil)
    }
    
    private func saveCategory(named: String) {
        let category = Category(context: context)
        category.name = named
        saveContext()
        self.categoriesCollectionView.reloadData()
    }
    
    private func showAddCategoryAlert() {
        let alertController = UIAlertController(title: Localization.addCategoryTitle, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localization.ok, style: .default) { [weak alertController] action in
            let textfield = alertController?.textFields?.first
            self.saveCategory(named: textfield!.text!)
        }
        let cancelAction = UIAlertAction(title: Localization.cancel, style: .cancel, handler: nil)
        alertController.addTextField { textField in
            textField.placeholder = Localization.category
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func selectSourceType(sourceType: UIImagePickerController.SourceType) {
        let pickerViewController = UIImagePickerController()
        pickerViewController.delegate = self
        pickerViewController.sourceType = sourceType
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    private func getFormattedDuration() -> String {
        var result = ""
        if let hours = durationHoursTextField.text {
            result = "\(hours)h"
            if let minutes = durationMinutesTextField.text {
                result = "\(result) \(minutes)min"
            } else {
                result = "\(result) \0min"
            }
        } else {
            if let minutes = durationMinutesTextField.text {
                result = "0h \(minutes)min"
            }
        }
        return result
    }
    
    private func createMovieToBeSaved() {
        let title = self.movieTitleTextField.text
        let summary = self.movieSummaryTextView.text
        var imageData: Data?
        if pictureChanged {
            if let image = coverImageView.image {
                imageData = image.jpegData(compressionQuality: 1.0)
            }
        }
        let duration = getFormattedDuration()
        let rating = Double(currentRatingLabel.text!)
        let categories = self.categoriesDataSource.selectedCategories
        let req = SaveMovie.Request(title: title, summary: summary, imageData: imageData, duration: duration, categories: categories, rating: rating)
        interactor?.saveMovie(request: req)
    }
    
    private func isCameraAvailable() -> Bool {
        return  UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    // MARK: - IBAction methods
    @IBAction func back(_ sender: Any?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingChanged(_ sender: UISlider) {
        interactor?.changeRating(request: ChangeRating.Request(value: sender.value))
    }
    
    @IBAction func save() {
        createMovieToBeSaved()
    }
    
    @IBAction func selectPhoto() {
        
        let actionSheet = UIAlertController(title: Localization.photoSourceMessage, message: nil, preferredStyle: .actionSheet)
        
        if isCameraAvailable() {
            let cameraAction = UIAlertAction(title: Localization.camera, style: .default) {[weak self] action in
                self?.selectSourceType(sourceType: .camera)
            }
            actionSheet.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: Localization.photoSourceGallery, style: .default) {[weak self] action in
            self?.selectSourceType(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: Localization.cancel, style: .cancel) {[weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension RegisterEditMovieViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let originalImage = info[.originalImage] as? UIImage else { return }
        let smallImage = originalImage.resizedTo(maxDimension: CGFloat(800))
        self.coverImageView.image = smallImage
        dismiss(animated: true, completion: nil)
        pictureChanged = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension RegisterEditMovieViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.hourPickerView {
            return 13
        }
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.hourPickerView {
            self.durationHoursTextField.text = "\(row)"
        } else {
            self.durationMinutesTextField.text = "\(row)"
        }
    }
}

extension RegisterEditMovieViewController: CategoriesCoreDataProviderDelegate {
    func dataDidChange() {
        self.loadCategories()
    }
}

extension RegisterEditMovieViewController: CategoriesDataSourceDelegate {
    func shouldDisplayAddCategoryAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.showAddCategoryAlert()
        }
    }
}

extension RegisterEditMovieViewController: RegisterEditDisplayLogic {
    func displayCategories(viewModel: LoadCategories.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.categoriesDataSource.categories = viewModel.categories ?? []
            self?.categoriesCollectionView.reloadData()
        }
    }

    func displaySavedMovie(viewModel: SaveMovie.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func displayChangedRating(viewModel: ChangeRating.ViewModel) {
        DispatchQueue.main.async { [weak self] in            self?.currentRatingLabel.text = viewModel.formattedValue
        }
    }
}
