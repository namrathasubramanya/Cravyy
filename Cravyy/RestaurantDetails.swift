//
//  RestaurantDetails.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/16/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import MaterialComponents
import MaterialComponents.MaterialAppBar

class RestaurantDetails: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    var passedRestaurantId: String!
    var establishmentOrNot: String!
    var locationManager:CLLocationManager = CLLocationManager()
    var sourceLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var activityIndicatorView: UIActivityIndicatorView!
    
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var localityName: UILabel!
    @IBOutlet weak var restaurantLocation: MKMapView!
    @IBOutlet weak var averageCostforTwo: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantNumber: UILabel!
    @IBOutlet weak var placeOrder: MDCButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.restaurantLocation.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        restaurantLocation.showsUserLocation = true
        fetchRestaurantDetails()
        restaurantName.numberOfLines = 0
        restaurantNumber.numberOfLines = 0
        localityName.numberOfLines = 0
        averageCostforTwo.numberOfLines = 0
        cuisine.numberOfLines = 0
        restaurantAddress.numberOfLines = 0
        let buttonScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: placeOrder)
        placeOrder.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
    }
    
    func fetchRestaurantDetails() {
        var urlString = "https://developers.zomato.com/api/v2.1/restaurant?res_id="
        urlString.append(passedRestaurantId)
        let url = NSURL(string: urlString)
        if url != nil {
            DispatchQueue.main.async(execute: {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            })
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
                            let restaurantDetails = try jsonDecoder.decode(RestaurantDetailsModel.self, from: data!)
                            let name = restaurantDetails.name
                            let cuisine = restaurantDetails.cuisines
                            let locality = restaurantDetails.location.locality
                            var phoneNumber = restaurantDetails.user_rating.aggregate_rating
                            phoneNumber?.append(contentsOf: " ")
                            phoneNumber?.append(contentsOf: restaurantDetails.user_rating.rating_text)
                            let latitude = restaurantDetails.location.latitude
                            let longitude = restaurantDetails.location.longitude
                            var costForTwo = String(restaurantDetails.currency)
                            costForTwo.append(contentsOf: String(restaurantDetails.average_cost_for_two))
                            let address = restaurantDetails.location.address
                            if let url = URL(string: restaurantDetails.thumb ?? "https://ibb.co/G0qjRWJ") {
                                if let data = try? Data( contentsOf: url) {
                                    DispatchQueue.main.async {
                                        self.featuredImage.image = UIImage(data:data)
                                    }
                                }
                            }
                            DispatchQueue.main.async(execute: {
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                                self.averageCostforTwo.text = String(costForTwo)
                                self.cuisine.text = cuisine
                                self.localityName.text = locality
                                self.restaurantNumber.text = phoneNumber
                                self.restaurantAddress.text = address
                                self.restaurantName.text = name
                            })
                            let restuarantLocation = CLLocationCoordinate2D(latitude: (latitude! as NSString).doubleValue, longitude: (longitude! as NSString).doubleValue)
                            let restaurantPlace = MapAnnotation(title: name!, subtitle: cuisine!, coordinate: restuarantLocation)
                            
                            let region = MKCoordinateRegion(center: restuarantLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                            DispatchQueue.main.async(execute: {
                            self.restaurantLocation.addAnnotation(restaurantPlace)
                            self.restaurantLocation.setRegion(region, animated: false)
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
}
