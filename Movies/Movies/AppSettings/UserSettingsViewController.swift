//
//  UserSettingsViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {

    let userSettings = UserSettingsManager.shared

    override func loadView() {
        view = SettingsView(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let themeColor = userSettings.currentThemeColor()
        guard let currentView = view as? SettingsView else { return }
        
        switch themeColor {
        case .black:
            currentView.themeColorSegmentedControl.selectedSegmentIndex = 0
        case .green:
            currentView.themeColorSegmentedControl.selectedSegmentIndex = 1
        case .orange:
            currentView.themeColorSegmentedControl.selectedSegmentIndex = 2
        }
        
        let autoPlay = userSettings.autoPlay()
        currentView.autoPlaySwitch.setOn(autoPlay, animated: true)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.applySettings()
    }

}

extension UserSettingsViewController: SettingsDelegate {
    
    func userChangedAutoPlay(to state: Bool) {
        userSettings.changeAutoPlay(to: state)
    }
    
    func userChangedThemeColor(to position: Int) {
        switch position {
        case 0:
            userSettings.changeTheme(with: ThemeColor.black)
        case 1:
            userSettings.changeTheme(with: ThemeColor.green)
        case 2:
            userSettings.changeTheme(with: ThemeColor.orange)
        default:
            userSettings.changeTheme(with: ThemeColor.black)
        }
    }

}
