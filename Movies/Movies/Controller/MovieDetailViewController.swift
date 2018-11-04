//
//  ViewController.swift
//  Movies
//
//  Created by Rodrigo Morbach on 04/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    public var movie: Movie?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildScreen()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - Private methods
    private func buildScreen() {
        guard let movie = self.movie else { return }
        if movie.image != nil {
            self.coverImageView.image = UIImage(named: movie.image!)
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
    }

    
    // MARK: IBAction methods
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

