//
//  HomeScreen.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/3/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialTextFields



class HomeScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var passedCityIdValue: Int!
    var valueToPass: Int!
    var cat = [Categories]()
    @IBOutlet weak var collectionView: UICollectionView!

     var items = ["delivery", "dineout", "nightlife", "catchingup", "takeaway", "cafes", "dailymenu", "breakfast", "lunch", "dinner", "pubsNbars", "pocketfriendly", "clubs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        collectionView.dataSource = self
        collectionView.delegate = self
        print(passedCityIdValue!)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func fetchCategories() {
            let urlString = "https://developers.zomato.com/api/v2.1/categories";
            let url = NSURL(string: urlString)
            if url != nil {
                let request = NSMutableURLRequest(url: url! as URL)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue(zomatoKey, forHTTPHeaderField: "user_key")

                let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
                    if error == nil {
                        let httpResponse = response as! HTTPURLResponse
                        if httpResponse.statusCode == 200 {
                            do {
                                let jsonDecoder = JSONDecoder()
                                let categoryNames = try jsonDecoder.decode(CategoryArray.self, from: data!)
                                print(categoryNames.categories)
                                self.cat = categoryNames.categories
                                DispatchQueue.main.async(execute: {
                                    self.collectionView.reloadData()
                                })
                            } catch {
                                print("Error ")
                                print(error)
                            }
                        }
                    }
                })
            task.resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cat.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! CollectionCell
        cell.categoryLabel.text = cat[indexPath.item].categories.name!
        print(cat[indexPath.item].categories.name!)
        cell.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        cell.tintColor = .white
        cell.cornerRadius = 8
        cell.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cell.setShadowColor(UIColor.black, for: .highlighted)
        let img : UIImage = UIImage(named: String(items[indexPath.item]))!
        cell.categoryImage.image = img
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected category id #\(String(describing: cat[indexPath.item].categories.id))!")
        valueToPass = cat[indexPath.item].categories.id
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantList") as? RestaurantList
        viewController?.passedCategoryIdValue = valueToPass
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}

class CollectionCell: MDCCardCollectionCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
}
