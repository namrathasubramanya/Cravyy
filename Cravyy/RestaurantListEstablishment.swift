//
//  RestaurantListEstablishment.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/16/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit

class RestaurantListEstablishment: UITableViewController {
    var activityIndicatorView: UIActivityIndicatorView!
    var passedEstablishmentIdValue: Int!
    @IBOutlet var restaurantEstablishmentTableView: UITableView!
    var restaurantEstablishments = [RestaurantsEstablishment]()
    var start: Int = 0
    var limit: Int = 100
    var count: Int = 20
    var checkAppend: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Restaurants"
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        restaurantEstablishmentTableView.backgroundView = activityIndicatorView
        getRestaurantEstablishmentList(start: start, count: count)
        restaurantEstablishmentTableView.dataSource = self
        restaurantEstablishmentTableView.delegate = self
    }
    func getRestaurantEstablishmentList(start: Int, count: Int) {
        var urlString = "https://developers.zomato.com/api/v2.1/search?"
        urlString.append("entity_id=")
        let userDefaults = UserDefaults.standard
        urlString.append(userDefaults.string(forKey: "City")!)
        urlString.append("&entity_type=city")
        urlString.append("&establishment_type=")
        urlString.append(String(passedEstablishmentIdValue))
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
                            let restaurantSearch = try jsonDecoder.decode(RestaurantSearchEstablishment.self, from: data!)
                            if self.checkAppend == true {
                                self.restaurantEstablishments.append(contentsOf: restaurantSearch.restaurants)
                            } else {
                                self.restaurantEstablishments = restaurantSearch.restaurants
                            }
                            DispatchQueue.main.async(execute: {
                                self.activityIndicatorView.stopAnimating()
                                self.restaurantEstablishmentTableView.reloadData()
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
        return restaurantEstablishments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantEstablishmentCell", for: indexPath) as! RestaurantEstablishmentCell
        let name = restaurantEstablishments[indexPath.row].restaurant.name
        let address = restaurantEstablishments[indexPath.row].restaurant.location.address
        let rating = restaurantEstablishments[indexPath.row].restaurant.user_rating.aggregate_rating
        let image = restaurantEstablishments[indexPath.row].restaurant.thumb
        let cuisine = restaurantEstablishments[indexPath.row].restaurant.cuisines
        cell.restaurantEstablishmentName.text = name
        cell.restaurantEstablishmentName.numberOfLines = 0
        cell.restaurantEstablishmentAddress.text = address
        cell.restaurantEstablishmentRating.text = rating
        cell.restaurantEstablishmentCuisine.text = cuisine
        cell.restaurantEstablishmentCuisine.numberOfLines = 0
        cell.restaurantEstablishmentAddress.numberOfLines = 0
        if let url = URL(string: image ?? "https://ibb.co/G0qjRWJ") {
            if let data = try? Data( contentsOf: url) {
                DispatchQueue.main.async {
                    cell.restaurantEstablishmentThumbnail.image = UIImage(data:data)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == restaurantEstablishments.count - 1 {
            start = start + count; // last cell
            if start < limit {
                checkAppend = true
                getRestaurantEstablishmentList(start: start, count: count)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDetails") as? RestaurantDetails
        viewController?.establishmentOrNot = "Establishment"
        viewController?.passedRestaurantId = restaurantEstablishments[indexPath.item].restaurant.id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
   
}

class RestaurantEstablishmentCell: UITableViewCell {
    
    @IBOutlet weak var restaurantEstablishmentName: UILabel!
    @IBOutlet weak var restaurantEstablishmentAddress: UILabel!
    
    @IBOutlet weak var restaurantEstablishmentCuisine: UILabel!
    @IBOutlet weak var restaurantEstablishmentRating: UILabel!
    @IBOutlet weak var restaurantEstablishmentThumbnail: UIImageView!
}
