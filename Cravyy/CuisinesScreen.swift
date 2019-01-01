//
//  CuisinesScreen.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/15/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialTextFields

class CuisinesScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var activityIndicatorView: UIActivityIndicatorView!
    var cuisines = [Cuisine]()
    var passedCityIdValue: Int!
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        cuisineCollectionView.backgroundView = activityIndicatorView
        navigationController?.title = "Cuisines"
        fetchCuisines()
        cuisineCollectionView.dataSource = self
        cuisineCollectionView.delegate = self
    }
    
    func fetchCuisines() {
        var urlString = "https://developers.zomato.com/api/v2.1/cuisines?city_id="
        urlString.append(String(passedCityIdValue!))
        let url = NSURL(string: urlString)
        if url != nil {
            activityIndicatorView.startAnimating()
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
                          let cuisineNames = try jsonDecoder.decode(Cuisines.self, from: data!)
                            if cuisineNames.cuisines != nil {
                                self.cuisines = cuisineNames.cuisines
                            }
                            DispatchQueue.main.async(execute: {
                                self.activityIndicatorView.stopAnimating()
                                self.cuisineCollectionView.reloadData()
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
        return cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisineCell",
                                                      for: indexPath) as! CuisineCollectionCell
        cell.cuisineName.text = cuisines[indexPath.item].cuisine.cuisine_name
        cell.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        cell.tintColor = .white
        cell.cornerRadius = 8
        cell.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cell.setShadowColor(UIColor.black, for: .highlighted)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantList") as? RestaurantList
        viewController?.option = "Cuisine"
        viewController?.passedCuisineIdValue = cuisines[indexPath.item].cuisine.cuisine_id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}

class CuisineCollectionCell: MDCCardCollectionCell {
    
    @IBOutlet weak var cuisineName: UILabel!
}
