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

protocol MovieDetailDisplayLogic: class {
    func displayMovie(viewModel: Display.ViewModel)
    func playMovieTrailer(viewModel: VideoPlay.ViewModel)
    func displayMovieSchedule(viewModel: PrepareSchedule.ViewModel)
    func displaySchedule(viewModel: Schedule.ViewModel)
    func displaySettings(viewModel: Settings.ViewModel)
    func displayCancelSchedule(viewModel: CancelSchedule.ViewModel)
    func displayRemovedNotificationSchedule(viewModel: RemovePendingNotification.ViewModel)
}

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
    
    var interactor: (MovieDetailBusinessLogic & MovieDetailDataStore)?
    var router: (MovieDetailRoutingLogic & MovieDetailDataPassing)?
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
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
    
    private func setup() {
        let viewController = self
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter()
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        let router = MovieDetailRouter()
        viewController.router = router
        viewController.interactor = interactor
        router.dataStore = interactor
    }
    
    private func buildScreen() {
        let request = Display.Request(movie: nil)
        interactor?.showMovie(request: request)
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
    
    private func removePendingNotification() {
        let request = RemovePendingNotification.Request()
        interactor?.removePendingNotification(request: request)
    }
    
    private func cancelSchedule() {
        self.schedule = false
        let request = CancelSchedule.Request()
        interactor?.cancelSchedule(request: request)
    }
    
    @objc private func doneSelectingDate() {
        scheduleTextField.text = datePicker.date.format
        let request = Schedule.Request(date: datePicker.date)
        interactor?.scheduleMovie(request: request)
    }
    
    @objc private func cancelSelectingDate() {
        view.endEditing(true)
    }
    
    // MARK: Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.routeToEditScreen(with: segue)
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
            let request = PrepareSchedule.Request(state: .schedule)
            interactor?.prepareToScheduleMovie(request: request)
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
    
    func callTrailerService() {
        let request = VideoPlay.Request(movieTitle: interactor!.movie!.title!)
        interactor?.playMovieTrailer(request: request)
    }
    
    func tryToPlay() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        callTrailerService()
    }
    
}

extension MovieDetailViewController: MovieDetailDisplayLogic {
    func displayMovie(viewModel: Display.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            
            self?.coverImageView.image = viewModel.coverImage
            self?.titleLabel.text = viewModel.title
            self?.ratingLabel.text = viewModel.rating
            self?.categoriesLabel.text = viewModel.categories
            self?.durationLabel.text = viewModel.duration
            self?.summaryLabel.text = viewModel.summary
            self?.summaryTextView.text = viewModel.summary
            
            if viewModel.notificationDate != nil {
                self?.datePicker.date = viewModel.notificationDate!
                self?.scheduleTextField.text = viewModel.notificationText!
                self?.schedule = true
            } else {
                self?.schedule = false
            }
        }
    }
    
    func playMovieTrailer(viewModel: VideoPlay.ViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            self?.spinner.stopAnimating()
            self?.spinner.isHidden = true
            switch viewModel {
            case .success(let trailerUrl):
                self?.playVideo(for: trailerUrl)
            case .error(let message):
                self?.showAlert(with: Localization.error, message: message)
            }
        }
    }
    
    func displayMovieSchedule(viewModel: PrepareSchedule.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            switch viewModel {
            case .error:
                self?.cancelSchedule()
            case .success:
                UIView.animate(withDuration: 0.4) {
                    self?.scheduleDateStackView.isHidden = false
                }
            }
        }
    }
    
    func displaySchedule(viewModel: Schedule.ViewModel) {
        //
        DispatchQueue.main.async { [weak self] in
            switch viewModel {
            case .success:
                self?.cancelSelectingDate()
            default: break
            }
        }
    }
    
    func displaySettings(viewModel: Settings.ViewModel) {
        DispatchQueue.main.async {
            switch viewModel {
            case .success(let settingsUrl):
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)            
            }
        }
    }
    
    func displayCancelSchedule(viewModel: CancelSchedule.ViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let message = viewModel.alertMessage
            let alert = UIAlertController(title: viewModel.alertTitle, message: message, preferredStyle: .alert)
            
            let openSettingsAction = UIAlertAction(title: viewModel.actionOpenSettings, style: .default) { action in
                let request = Settings.Request()
                self?.interactor?.openSettings(request: request)
            }
            
            let cancelAction = UIAlertAction(title: viewModel.actionCancel, style: .cancel) {[weak self] action in
                self?.dismiss(animated: true, completion: nil)
            }
            alert.addAction(openSettingsAction)
            alert.addAction(cancelAction)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayRemovedNotificationSchedule(viewModel: RemovePendingNotification.ViewModel) {
        // Nothing todo here
    }
    
}
