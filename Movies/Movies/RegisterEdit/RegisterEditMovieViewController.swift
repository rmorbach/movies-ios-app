//
//  RegisterEditMovieViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData

class RegisterEditMovieViewController: UIViewController {
    
    var editingMovie: Movie?
    var selectedCategories = Set<Category>()
    var pictureChanged = false
    var categoriesDataProvider: CategoriesCoreDataProvider?
    var categories = [Category]()
    
    lazy var hourPickerView: UIPickerView = {
        let pkv = UIPickerView()
        pkv.delegate = self
        pkv.dataSource = self;
        return pkv
    }()
    
    lazy var minutesPickerView: UIPickerView = {
        let pkv = UIPickerView()
        pkv.delegate = self
        pkv.dataSource = self;
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
        self.categoriesCollectionView.delegate = self
        self.categoriesCollectionView.dataSource = self
        
        if editingMovie != nil && editingMovie?.categories != nil {
            if let setCategories = editingMovie!.categories as? Set<Category> {
                selectedCategories = setCategories
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
            self.title = "Cadastrar filme"
            return
        }
        self.title = "Editar filme"
        buildScreen(movie: movieToEdit)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removerObservers()
    }
    
    
    // MARK: - Private methods
    
    private func prepareTextFields() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let okBarButtonItem = UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneSelecting))
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelSelecting))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelBarButtonItem, flexibleSpace, okBarButtonItem]
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
    
    private func loadCategories() {
        categoriesDataProvider?.fetch(completion: { [weak self] error, loadedCategories in
            if error == nil {
                self?.categories = loadedCategories ?? []
                DispatchQueue.main.async {
                    self?.categoriesCollectionView.reloadData()
                }
            }
        })
    }
    
    private func saveCategory(named: String) {
        let category = Category(context: context)
        category.name = named
        saveContext()
        self.categoriesCollectionView.reloadData()
    }
    
    private func showAddCategoryAlert() {
        let alertController = UIAlertController(title: "Adicionar categoria", message: nil, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [weak alertController] action in
            let textfield = alertController?.textFields?.first
            self.saveCategory(named: textfield!.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil);
        alertController.addTextField { textField in
            textField.placeholder = "Categoria"
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func selectSourceType(sourceType: UIImagePickerController.SourceType) {
        let pickerViewController = UIImagePickerController()
        pickerViewController.delegate = self;
        pickerViewController.sourceType = sourceType
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    // MARK: - IBAction methods
    @IBAction func back(_ sender: Any?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingChanged(_ sender: UISlider) {
        currentRatingLabel.text = String(format: "%\(0.2)f", sender.value)
    }
    
    @IBAction func save() {
        if editingMovie == nil {
            editingMovie = Movie(context: context)
        }
        editingMovie?.title = self.movieTitleTextField.text
        editingMovie?.summary = self.movieSummaryTextView.text
        if let rating = Double(currentRatingLabel.text!) {
            editingMovie?.rating = rating
        }
        if pictureChanged {
            if let image = coverImageView.image {
                let imageData = image.jpegData(compressionQuality: 1.0)
                editingMovie?.imageData = imageData
            }
        }
        
        if let hours = durationHoursTextField.text {
            var hoursString = "\(hours)h"
            if let minutes = durationMinutesTextField.text {
                hoursString = "\(hoursString) \(minutes)min"
            } else {
                hoursString = "\(hoursString) \0min"
            }
            editingMovie?.duration = hoursString
        } else {
            if let minutes = durationMinutesTextField.text {
                editingMovie?.duration = "0h \(minutes)min"
            }
        }
        
        editingMovie?.categories = selectedCategories as NSSet
        saveContext()
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func selectPhoto() {
        
        let actionSheet = UIAlertController(title: "Capturar de onde?", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: UIAlertAction.Style.default) {[weak self] action in
                self?.selectSourceType(sourceType: .camera)
            }
            actionSheet.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Galeria", style: UIAlertAction.Style.default) {[weak self] action in
            self?.selectSourceType(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) {[weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    
    }
    
}

extension RegisterEditMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        if let categoryCell = cell as? MovieCategoryCollectionViewCell {
            let category = categories[indexPath.row]
            
            if selectedCategories.contains(category) {
                selectedCategories.remove(category)
                categoryCell.state = .unselected
            } else {
                selectedCategories.insert(category)
                categoryCell.state = .selected
            }
        } else {
            showAddCategoryAlert()
        }
    }
}

extension RegisterEditMovieViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // +1 to show add category cell
        let counter = categories.count
        return (counter > 0) ? counter + 1 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let counter = categories.count
        
        //Last cell of the list
        if indexPath.row == counter {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "addCategoryCell", for: indexPath)
        }
        
        //Regular cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCategoryCollectionViewCell.cellIdentifier, for: indexPath) as? MovieCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        
        cell.prepareCell(category: category)
        
        if selectedCategories.contains(category) {
            cell.state = .selected
        } else {
            cell.state = .unselected
        }

        return cell
    }
    
}

extension RegisterEditMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let counter = categories.count
        //Last cell of the list
        if indexPath.row < counter {
            return CGSize(width: 120, height: 40)
        }
        
        return CGSize(width: 50, height: 40)
    }
}

extension RegisterEditMovieViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[.originalImage] as? UIImage else { return }
        let smallImage = originalImage.resizedTo(maxDimension: CGFloat(800))
        self.coverImageView.image = smallImage
        dismiss(animated: true, completion: nil)
        pictureChanged = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //pickerViewController.dismiss(animated: true, completion: nil)
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
