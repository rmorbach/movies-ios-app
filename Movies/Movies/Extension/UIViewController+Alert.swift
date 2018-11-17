//
//  UIViewController+Alert.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
extension UIViewController {
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
