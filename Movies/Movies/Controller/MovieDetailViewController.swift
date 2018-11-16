//
//  ViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import UserNotifications

class MovieDetailViewController: UIViewController {

    public var movie: Movie?
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        return dp
    }()
    
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
    
    @IBOutlet weak var scheduleDateStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        prepareTextField()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buildScreen()
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
            self.scheduleSwitch.setOn(true, animated: true)
            UIView.animate(withDuration: 0.4) {
                self.scheduleDateStackView.isHidden = false
            }
        } else {
            self.scheduleSwitch.setOn(false, animated: true)
            UIView.animate(withDuration: 0.4) {
                self.scheduleDateStackView.isHidden = true
            }
        }
        
        
    }
    
    func prepareTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let okBarButtonItem = UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneSelectingDate))
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelSelectingDate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelBarButtonItem, flexibleSpace, okBarButtonItem]
        self.scheduleTextField.inputView = datePicker
        self.scheduleTextField.inputAccessoryView = toolbar
     
    }
    
    private func scheduleMovie(with identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Lembrete 📽"
        content.body = "Tá na hora de assistir \(movie!.title!)"
        
        //Agrupa notificações
        content.categoryIdentifier = "lembrete"
        let components = Calendar.current.dateComponents([.month, .year, .day, .hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            
        }
            
    }
    
    private func askNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("authorized")
            case .denied:
                print("denied")
                self?.cancelShedule()
            case .notDetermined:
                print("notDetermined")
            case .provisional:
                print("provisional")
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: "confirm", title: "OK", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancelar", options: [])
        
        let category = UNNotificationCategory(identifier: "lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
        
        center.setNotificationCategories([category])
        
        center.requestAuthorization(options: [.alert, .badge]) {[weak self] success, error in
            if !success {
                self?.cancelShedule()
            }
        }
        
    }
    
    private func removePendingNotification() {
        guard let pedingIdentifer = movie?.notification?.id else {
            return
        }
        movie!.notification = nil
        saveContext()
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [pedingIdentifer])
    }
    
    private func cancelShedule() {
        UIView.animate(withDuration: 0.4) {
            DispatchQueue.main.async {
                self.scheduleSwitch.setOn(false, animated: true)
                self.scheduleDateStackView.isHidden = true
            }
        }
        let alert = UIAlertController(title: "😢", message: "Você precisa habilitar as notificações para que possamos te lembrar de assistir um filme", preferredStyle: UIAlertController.Style.alert)
        let openSettingsAction = UIAlertAction(title: "Configurações", style: UIAlertAction.Style.default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) {[weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(openSettingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    @objc func doneSelectingDate() {
        
        scheduleTextField.text = datePicker.date.format
        if movie?.notification == nil {
            movie?.notification = Notification(context: context)
        }
        movie?.notification!.date = datePicker.date
        let id = String(Date().timeIntervalSince1970)
        movie?.notification!.id = id
        saveContext()
        scheduleMovie(with: id)
        cancelSelectingDate()
    }
    @objc func cancelSelectingDate() {
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
            askNotificationPermission()
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
    
}


extension MovieDetailViewController : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        switch identifier {
        case "confirm":
            print("confirm clicked")
        case "cancel":
            print("cancel clicked")
        case UNNotificationDefaultActionIdentifier:
            print("notification clicked")
        case UNNotificationDismissActionIdentifier:
            print("dismiss")
        default:
            break
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
