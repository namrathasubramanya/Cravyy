//
//  RestaurantList.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/8/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit

class RestaurantList: UITableViewController {
    var activityIndicatorView: UIActivityIndicatorView!
    var passedCityIdValue: Int!
    var option: String!
    var passedCategoryIdValue: Int!
    var passedCuisineIdValue: Int!
    var passedCollectionIdValue: Int!
    var start: Int = 0
    var limit: Int = 100
    var count: Int = 20
    var checkAppend: Bool = false
   
    var restaurants = [Restaurants]()
    @IBOutlet var restaurantView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Restaurants"
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        restaurantView.backgroundView = activityIndicatorView
        getRestaurantList(start: start, count: count)
        restaurantView.dataSource = self
        restaurantView.delegate = self
    }
    
    func getRestaurantList(start: Int, count: Int) {
        var urlString = "https://developers.zomato.com/api/v2.1/search?"
        urlString.append("entity_id=")
        let userDefaults = UserDefaults.standard
        urlString.append(userDefaults.string(forKey: "City")!)
        urlString.append("&entity_type=city")
        if(option == "Category") {
            urlString.append("&category=")
            urlString.append(String(passedCategoryIdValue))
        } else if (option == "Cuisine") {
            urlString.append("&cuisines=")
            urlString.append(String(passedCuisineIdValue))
        } else if (option == "Collection") {
            urlString.append("&collection_id=")
            urlString.append(String(passedCollectionIdValue))
        }
        urlString.append("&start=")
        urlString.append(String(start))
        urlString.append("&count=")
        urlString.append(String(count))
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
                        do{
                            let jsonDecoder = JSONDecoder()
                            let restaurantSearch = try jsonDecoder.decode(RestaurantSearch.self, from: data!)
                            if self.checkAppend == true {
                                self.restaurants.append(contentsOf: restaurantSearch.restaurants)
                            } else {
                                if restaurantSearch.restaurants != nil {
                                    self.restaurants = restaurantSearch.restaurants!
                                } else {
                                    self.displayAlertMessage(message: "No Restaurants found")
                                }
                            }
                            DispatchQueue.main.async(execute: {
                                self.activityIndicatorView.stopAnimating()
                                self.restaurantView.reloadData()
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
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurant", for: indexPath) as! RestaurantCell
        let name = restaurants[indexPath.row].restaurant!.name
        let address = restaurants[indexPath.row].restaurant!.location.address
        let rating = restaurants[indexPath.row].restaurant.user_rating.aggregate_rating
        let image = restaurants[indexPath.row].restaurant.thumb
        let cuisine = restaurants[indexPath.row].restaurant.cuisines
        cell.restaurantName.text = name
        cell.restaurantName.numberOfLines = 0
        cell.restaurantAddress.text = address
        cell.restaurantRating.text = rating
        cell.restaurantCuisine.text = cuisine
        cell.restaurantCuisine.numberOfLines = 0
        cell.restaurantAddress.numberOfLines = 0
        if let url = URL(string: image ?? "https://ibb.co/G0qjRWJ") {
            if let data = try? Data( contentsOf: url) {
                DispatchQueue.main.async {
                    cell.restaurantThumbnail.image = UIImage(data:data)
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == restaurants.count - 1 {
            start = start + count; // last cell
            if start < limit {
                checkAppend = true
                getRestaurantList(start: start, count: count)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDetails") as? RestaurantDetails
        viewController?.establishmentOrNot = "NotEstablishment"
       viewController?.passedRestaurantId = restaurants[indexPath.item].restaurant.id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func displayAlertMessage(message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
}

class RestaurantCell: UITableViewCell {
    
 
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantCuisine: UILabel!
    @IBOutlet weak var restaurantRating: UILabel!
    @IBOutlet weak var restaurantThumbnail: UIImageView!
}
