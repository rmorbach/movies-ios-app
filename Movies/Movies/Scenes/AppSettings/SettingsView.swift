//
//  SettingsView.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

protocol SettingsDelegate: class {
    func userChangedAutoPlay(to state: Bool)
    func userChangedThemeColor(to position: Int)
}

final class SettingsView: UIView {
    
    weak var delegate: SettingsDelegate?
    
    let autoPlaySwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    let autoPlayLabel: UILabel = {
       let label = UILabel(frame: .zero)
       label.text = Localization.settingsAutoPlay
       label.font = .body
       label.textColor = Color.defaultFontColor
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    var autoPlayStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let themeColorLabel: UILabel = {
        let themeLabel = UILabel(frame: .zero)
        themeLabel.text = Localization.settingsMainColor
        themeLabel.font = .body
        themeLabel.textColor = Color.defaultFontColor
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
       return themeLabel
    }()
    
    let themeColorSegmentedControl: UISegmentedControl = {
       let items: [String] = [Localization.settingsColorBlack, Localization.settingsColorGreen, Localization.settingsColorOrange]
       let segmentedControl = UISegmentedControl(items: items)
       segmentedControl.tintColor = Color.defaultFontColor
       segmentedControl.translatesAutoresizingMaskIntoConstraints = false
       return segmentedControl
    }()
    
    var themeColorStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20.0
        return stack
    }()
    
    var settingsStackView: UIStackView = {
       let stack = UIStackView(frame: .zero)
       stack.axis = .vertical
       stack.alignment = .fill
       stack.distribution = .fillEqually
       stack.spacing = 20.0
       stack.translatesAutoresizingMaskIntoConstraints = false
       return stack
    }()
    
    init(delegate: SettingsDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setup()
    }
    
    //Sempre necessário pois é usado por exemplo quando a View vem a partir do XIB ou Storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingsView: CodeView {
    func setupComponents() {
        autoPlayStackView.addArrangedSubview(autoPlayLabel)
        autoPlayStackView.addArrangedSubview(autoPlaySwitch)
        
        themeColorStackView.addArrangedSubview(themeColorLabel)
        themeColorStackView.addArrangedSubview(themeColorSegmentedControl)
        
        settingsStackView.addArrangedSubview(autoPlayStackView)
        settingsStackView.addArrangedSubview(themeColorStackView)
        
        addSubview(settingsStackView)
    }
    
    func setupConstraints() {
        settingsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Margin.defaultMargin).isActive = true
        settingsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Margin.defaultMargin).isActive = true
        settingsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Margin.defaultMargin).isActive = true
        
    }
    
    func setupExtraConfiguration() {        
        autoPlaySwitch.addTarget(self, action: #selector(autoPlayChanged), for: UIControl.Event.valueChanged)
        themeColorSegmentedControl.addTarget(self, action: #selector(colorChanged), for: UIControl.Event.valueChanged)
        
    }
}

// MARK: - Action methods
extension SettingsView {
    
    @objc func autoPlayChanged() {
        delegate?.userChangedAutoPlay(to: autoPlaySwitch.isOn)
    }
    
    @objc func colorChanged() {
        delegate?.userChangedThemeColor(to: themeColorSegmentedControl.selectedSegmentIndex)
    }
    
}
