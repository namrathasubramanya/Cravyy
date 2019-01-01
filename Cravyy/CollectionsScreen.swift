//
//  CollectionsScreen.swift
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

class CollectionsScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var activityIndicatorView: UIActivityIndicatorView!
    var collections = [Collection]()
    var passedCityIdValue: Int!
    @IBOutlet weak var collectionsView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        collectionsView.backgroundView = activityIndicatorView
        navigationController?.title = "Collections"
        fetchCollections()
        collectionsView.delegate = self
        collectionsView.dataSource = self
    }
    
    func fetchCollections() {
        var urlString = "https://developers.zomato.com/api/v2.1/collections?city_id="
        urlString.append(String(passedCityIdValue!))
        urlString.append("&count=30")
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
                            let collectionNames = try jsonDecoder.decode(Collections.self, from: data!)
                            print(collectionNames)
                            if collectionNames.collections != nil {
                                self.collections = collectionNames.collections!
                            } else {
                                self.displayAlertMessage(message: "No data found")
                            }
                            DispatchQueue.main.async(execute: {
                                self.activityIndicatorView.stopAnimating()
                                self.collectionsView.reloadData()
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
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionsCell",
                                                      for: indexPath) as! CollectionsScreenCell
        cell.collectionsName.text = collections[indexPath.item].collection.title
        cell.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        cell.tintColor = .white
        cell.cornerRadius = 8
        cell.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cell.setShadowColor(UIColor.black, for: .highlighted)
        print(collections[indexPath.item].collection.image_url ?? "Nil")
        if let url = URL(string: collections[indexPath.item].collection.image_url ?? "https://ibb.co/G0qjRWJ") {
            if let data = try? Data( contentsOf: url) {
                DispatchQueue.main.async {
                    cell.collectionsImage.image = UIImage(data:data)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantList") as? RestaurantList
        viewController?.option = "Collection"
        viewController?.passedCollectionIdValue = collections[indexPath.item].collection.collection_id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func displayAlertMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

class CollectionsScreenCell: MDCCardCollectionCell {

    @IBOutlet weak var collectionsImage: UIImageView!
    @IBOutlet weak var collectionsName: UILabel!
}
