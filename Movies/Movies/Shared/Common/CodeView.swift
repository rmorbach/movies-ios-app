//
//  CodeView.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

protocol CodeView {
    func setupComponents()
    func setupConstraints()
    func setupExtraConfiguration()
    func setup()
}

extension CodeView {
    func setup() {
        setupComponents()
        setupConstraints()
        setupExtraConfiguration()
    }
}
