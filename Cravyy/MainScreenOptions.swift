//
//  MainScreenOptions.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/14/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialTextFields

class MainScreenOptions: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var passedCityIdValue: Int!
    @IBOutlet weak var collectionView: UICollectionView!
    var mainOptions = ["Categories","Collections","Cuisines","Establishments"]
    var mainOptionImages = ["categories","collections","cuisines","establishments"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainOptionCell",
        for: indexPath) as! MainOptionCollectionCell
        cell.optionName.text = mainOptions[indexPath.item]
        let img : UIImage = UIImage(named: mainOptionImages[indexPath.item])!
        cell.mainOptionImage.image = img
        cell.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        cell.tintColor = .white
        cell.cornerRadius = 8
        cell.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cell.setShadowColor(UIColor.black, for: .highlighted)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.item == 0) {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "CategoriesScreen") as? CategoriesScreen
            viewController?.passedCityIdValue = passedCityIdValue
            self.navigationController?.pushViewController(viewController!, animated: true)
        } else if(indexPath.item == 1) {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "CollectionsScreen") as? CollectionsScreen
                viewController?.passedCityIdValue = passedCityIdValue
            self.navigationController?.pushViewController(viewController!, animated: true)
        } else if(indexPath.item == 2) {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "CuisinesScreen") as? CuisinesScreen
            viewController?.passedCityIdValue = passedCityIdValue
            self.navigationController?.pushViewController(viewController!, animated: true)
        } else if(indexPath.item == 3) {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "EstablishmentsScreen") as? EstablishmentsScreen
            viewController?.passedCityIdValue = passedCityIdValue
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        
    }
    
}

class MainOptionCollectionCell: MDCCardCollectionCell {
    
    @IBOutlet weak var mainOptionImage: UIImageView!
    @IBOutlet weak var optionName: UILabel!
}
