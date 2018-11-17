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
    // MARK - IBOutlets
    
    @IBOutlet weak var themeColorStackView: UIStackView!
    @IBOutlet weak var autoPlaySwitch: UISwitch!
    @IBOutlet weak var themColorSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrangeStackView()
        let themeColor = userSettings.currentThemeColor()
        
        switch themeColor {
        case .black:
            themColorSegmentedControl.selectedSegmentIndex = 0
        case .blue:
            themColorSegmentedControl.selectedSegmentIndex = 1
        case .orange:
            themColorSegmentedControl.selectedSegmentIndex = 2
        }
        
        let autoPlay = userSettings.autoPlay()
        autoPlaySwitch.setOn(autoPlay, animated: true)
    }
    private func arrangeStackView() {
        if self.themeColorStackView == nil { return }
        if UIDevice.current.orientation.isLandscape {
            self.themeColorStackView.axis = .horizontal
        } else {
            self.themeColorStackView.axis = .vertical
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       arrangeStackView()
    }
    
    // MARK - IBActions

    @IBAction func changeAutoPlay(_ sender: UISwitch) {
        userSettings.changeAutoPlay(to: sender.isOn)
    }
    
    @IBAction func changeThemeColor(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            userSettings.changeTheme(with: ThemeColor.black)
        case 1:
            userSettings.changeTheme(with: ThemeColor.blue)
        case 2:
            userSettings.changeTheme(with: ThemeColor.orange)
        default:
            userSettings.changeTheme(with: ThemeColor.black)
        }
    }
}
