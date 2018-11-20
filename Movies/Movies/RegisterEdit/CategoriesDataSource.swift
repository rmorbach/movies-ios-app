//
//  CategoriesDataSource.swift
//  Movies
//
//  Created by Rodrigo Morbach on 20/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

protocol CategoriesDataSourceDelegate: class {
    func shouldDisplayAddCategoryAlert()
}

class CategoriesDataSource: NSObject {
    weak var delegate: CategoriesDataSourceDelegate?
    var categories = [Category]()
    var selectedCategories = Set<Category>()
}

extension CategoriesDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        if let categoryCell = cell as? MovieCategoryCollectionViewCell {
            let category = categories[indexPath.row]
            
            if selectedCategories.contains(category) {
                selectedCategories.remove(category)
                categoryCell.state = .unselected
            } else {
                selectedCategories.insert(category)
                categoryCell.state = .selected
            }
        } else {
            delegate?.shouldDisplayAddCategoryAlert()
        }
    }
}

extension CategoriesDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // +1 to show add category cell
        let counter = categories.count
        return (counter > 0) ? counter + 1 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt idxPath: IndexPath) -> UICollectionViewCell {
        
        let counter = categories.count
        
        //Last cell of the list
        if idxPath.row == counter {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "addCategoryCell", for: idxPath)
        }
        
        let identifier = MovieCategoryCollectionViewCell.cellIdentifier
        
        //Regular cell
        let cll = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: idxPath)
        
        if let cell = cll as? MovieCategoryCollectionViewCell {
            let category = categories[idxPath.row]
            
            cell.prepareCell(with: category)
            
            if selectedCategories.contains(category) {
                cell.state = .selected
            } else {
                cell.state = .unselected
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension CategoriesDataSource: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ clV: UICollectionView, layout clVL: UICollectionViewLayout, sizeForItemAt idxP: IndexPath) -> CGSize {
        
        let counter = categories.count
        
        if idxP.row < counter {
            return CGSize(width: 120, height: 40)
        }
        //Last cell of the list
        return CGSize(width: 50, height: 40)
    }
}
