//
//  NotificationManager.swift
//  Movies
//
//  Created by Rodrigo Morbach on 20/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Private methods
    private override init() { }
    
    private func checkUserPermission(completion: @escaping(_ authorized: Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            case .provisional:
                completion(true)
            case .notDetermined:
                completion(true)
            default:
                completion(false)
            }
        }
    }
    
    // MARK: - Public methods
    
    func userHasGrantedPermission(completion: @escaping(_ authorized: Bool) -> Void) {
        checkUserPermission { authorized in
            completion(authorized)
        }
    }
    
    func requestAuthorization(completion: @escaping (_ success: Bool) -> Void) {
        
        let confirmAction = UNNotificationAction(identifier: "confirm", title: Localization.notificationAnswerOk, options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "cancel", title: Localization.cancel, options: [])
        
        let ctgOpts: UNNotificationCategoryOptions = [.customDismissAction]
        
        let acts: [UNNotificationAction] = [confirmAction, cancelAction]
        
        let idtf = "lembrete"
        
        let ctg = UNNotificationCategory(identifier: idtf, actions: acts, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: ctgOpts)
        
        notificationCenter.setNotificationCategories([ctg])
        
        notificationCenter.requestAuthorization(options: [.alert, .badge]) { success, error in
            completion(success)
        }
    }
    
    func scheduleNotificationTriggerDate(identifier: String, title: String, body: String, triggerDate: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "reminder"
        
        let components = Calendar.current.dateComponents([.month, .year, .day, .hour, .minute], from: triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: nil)
        
    }
    
    func removeNotification(identifiers: [String]) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
}
