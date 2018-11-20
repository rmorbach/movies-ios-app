//
//  ViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import AVKit

class MovieDetailViewController: UIViewController {
    
    // MARK: Private properties
    private var playerViewController: AVPlayerViewController?
    private var videoAlreadyShown = false
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    private var schedule: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.scheduleSwitch.setOn(self?.schedule ?? false, animated: true)
                if self!.schedule {
                    UIView.animate(withDuration: 0.4) {
                        self?.scheduleDateStackView.isHidden = false
                    }
                } else {
                    self?.scheduleDateStackView.isHidden = true
                }
            }
        }
    }
    
    // MARK: Internals
    var movie: Movie?
    
    // MARK: IBOutlets
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var scheduleStackView: UIStackView!
    @IBOutlet weak var scheduleTextField: UITextField!
    @IBOutlet weak var scheduleSwitch: UISwitch!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scheduleDateStackView: UIStackView!
    
    // MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        prepareTextField()
        self.scheduleDateStackView.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIViewController.themeColor
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.buildScreen()
        if !videoAlreadyShown {
            if !UserSettingsManager.shared.autoPlay() {
                return
            }
            self.tryToPlay()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.playerViewController != nil && self.playerViewController?.player != nil {
            self.playerViewController?.player?.pause()
        }
    }
    
    // MARK: - Private methods
    private func buildScreen() {
        guard let movie = self.movie else { return }
        
        if movie.image != nil {
            self.coverImageView.image = movie.image
        }
        
        self.titleLabel.text = movie.title
        self.ratingLabel.text = movie.formattedRating
        self.categoriesLabel.text = movie.formattedCategorie
        self.durationLabel.text = movie.duration ?? ""
        
        if self.summaryLabel != nil {
            self.summaryLabel.text = movie.summary ?? ""
        }
        
        if self.summaryTextView != nil {
            self.summaryTextView.text = movie.summary ?? ""
        }
        
        if movie.notification != nil {
            datePicker.date = movie.notification!.date!
            scheduleTextField.text = datePicker.date.format
            self.schedule = true
        } else {
            self.schedule = false
        }
        
    }
    
    private func prepareTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let okButton = UIBarButtonItem()
        okButton.style = .done
        okButton.title = Localization.ok
        okButton.target = self
        okButton.action = #selector(doneSelectingDate)
        
        let cancelButton = UIBarButtonItem()
        cancelButton.title = Localization.cancel
        cancelButton.style = .plain
        cancelButton.target = self
        cancelButton.action = #selector(cancelSelectingDate)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, okButton]
        self.scheduleTextField.inputView = datePicker
        self.scheduleTextField.inputAccessoryView = toolbar
    }
    
    private func scheduleMovie(with identifier: String) {
        
        let title = Localization.notificationTitle
        let body = Localization.notificationMessage(movie!.title!)
        let date = datePicker.date
        NotificationManager.shared.scheduleNotificationTriggerDate(identifier: identifier, title: title, body: body, triggerDate: date)
    }
    
    private func checkNotificationPermission() {
        
        NotificationManager.shared.userHasGrantedPermission(completion: { [weak self] authorized in
            if !authorized {
                self?.cancelSchedule()
            }
        })
        
        NotificationManager.shared.requestAuthorization { [weak self] success in
            if !success {
                DispatchQueue.main.async {
                    self?.cancelSchedule()
                }
            }
        }
        
    }
    
    private func removePendingNotification() {
        guard let pendingIdentifer = movie?.notification?.id else {
            return
        }
        movie!.notification = nil
        saveContext()
        NotificationManager.shared.removeNotification(identifiers: [pendingIdentifer])
    }
    
    private func cancelSchedule() {
        self.schedule = false
        let message = Localization.notificationDenied
        let alert = UIAlertController(title: Localization.sad, message: message, preferredStyle: .alert)
        let openSettingsAction = UIAlertAction(title: Localization.settings, style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: Localization.cancel, style: .cancel) {[weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(openSettingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func doneSelectingDate() {
        scheduleTextField.text = datePicker.date.format
        if movie?.notification == nil {
            movie?.notification = Notification(context: context)
        }
        movie?.notification!.date = datePicker.date
        let identifier = String(Date().timeIntervalSince1970)
        movie?.notification!.id = identifier
        saveContext()
        scheduleMovie(with: identifier)
        cancelSelectingDate()
    }
    
    @objc private func cancelSelectingDate() {
        view.endEditing(true)
    }
    
    // MARK: Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVc = segue.destination as? RegisterEditMovieViewController else {
            return
        }
        destVc.editingMovie = self.movie
    }
    
    // MARK: IBAction methods
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editMovie(_ sender: Any) {
        self.performSegue(withIdentifier: "editMovieSegue", sender: nil)
    }
    
    @IBAction func toggleSchedule(_ sender: UISwitch) {
        if sender.isOn {
            checkNotificationPermission()
            UIView.animate(withDuration: 0.4) {
                self.scheduleDateStackView.isHidden = false
            }
        } else {
            self.scheduleTextField.text = ""
            self.removePendingNotification()
            UIView.animate(withDuration: 0.4) {
                self.scheduleDateStackView.isHidden = true
            }
        }
    }
    
    @IBAction func play(_ sender: Any) {
        tryToPlay()
    }
    
}

// MARK: - Player
extension MovieDetailViewController {
    
    /// This method should be called from the main thread
    ///
    /// - Parameter url: video url
    func playVideo(for url: URL) {
        let player = AVPlayer(url: url)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        videoAlreadyShown = true
        playerViewController?.player?.play()
        guard let playerVc = self.playerViewController else { return }
        present(playerVc, animated: true, completion: nil)
    }
    
    func callTraillerService() {
        let service = TraillerService()
        service.trailerUrlFor(movie: self.movie!.title!) {[weak self] previewUrlString, error in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                if error != nil {
                    self?.showAlert(with: Localization.error, message: error!.rawValue)
                    return
                }
                guard let url = URL(string: previewUrlString ?? "") else { return }
                self?.playVideo(for: url)
            }
        }
    }
    
    func tryToPlay() {
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        callTraillerService()
    }
    
}
