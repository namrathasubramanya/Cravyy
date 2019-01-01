//
//  CitySearch.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/8/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialTextFields
import MapKit
import CoreLocation

class CitySearch: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    var locationManager:CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var latitude : Double?
    var longitude : Double?
    var valueToPass: Int!
    var activityIndicatorView: UIActivityIndicatorView!
    var cityNames = [LocationSuggestion]()
    @IBOutlet weak var cityName: MDCTextField!
    @IBOutlet weak var citySearchButton: MDCButton!
    @IBOutlet weak var currentLocationButton: MDCButton!
    @IBOutlet weak var cityTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Select your city"
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        cityTable.backgroundView = activityIndicatorView
        let buttonScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: citySearchButton)
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: currentLocationButton)
        citySearchButton.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        currentLocationButton.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        cityTable.delegate = self
        cityTable.dataSource = self
    }
    
    func getCities() {
        let userDefaults = UserDefaults.standard
        let coordinates = userDefaults.string(forKey: "LatLong")
        var urlString = "https://developers.zomato.com/api/v2.1/cities?"
        if coordinates == "Yes" {
            urlString.append(contentsOf: "lat=")
            urlString.append(contentsOf: userDefaults.string(forKey: "latitude")!)
            urlString.append(contentsOf: "&lon=")
            urlString.append(contentsOf: userDefaults.string(forKey: "longitude")!)
        } else {
            urlString.append(contentsOf: "q=")
            let formattedString = String(cityName.text!.filter { !" \n\t\r".contains($0) })
            urlString.append(formattedString)
        }
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
                            let cities = try jsonDecoder.decode(LocationSuggestions.self, from: data!)
                            print(cities.location_suggestions)
                            self.cityNames = cities.location_suggestions
                            DispatchQueue.main.async(execute: {
                                self.activityIndicatorView.stopAnimating()
                                self.cityTable.reloadData()
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
    
    @IBAction func searchCity(_ sender: MDCButton) {
        print("********* BUTTON **********")
        let userDefaults = UserDefaults.standard
        userDefaults.set("No", forKey: "LatLong")
        getCities()
    }
    
    @IBAction func currentLocation(_ sender: MDCButton) {
        startLocation = nil
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = locValue.latitude
        longitude = locValue.longitude
        if startLocation == nil {
            locationManager.stopUpdatingLocation()
            if let lat = latitude, let long = longitude {
                displayAlertMessage(message: "User location updated")
                let userDefaults = UserDefaults.standard
                userDefaults.set(lat, forKey: "latitude")
                userDefaults.set(long, forKey: "longitude")
                userDefaults.set("Yes", forKey: "LatLong")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return cityNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citySearch", for: indexPath) as! CityCell
        let object = cityNames[indexPath.row]
        print(object.name)
        cell.cityLabel.text = object.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(cityNames[indexPath.row].id, forKey: "City")
        valueToPass = cityNames[indexPath.row].id
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MainScreenOptions") as? MainScreenOptions
        viewController?.passedCityIdValue = valueToPass
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func displayAlertMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            self.getCities()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

class CityCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
}
