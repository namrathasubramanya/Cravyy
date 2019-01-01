//
//  EstablishmentsScreen.swift
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

class EstablishmentsScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var establishmentCollectionView: UICollectionView!
    var passedCityIdValue: Int!
    var establishments = [Establishment]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Establishments"
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        establishmentCollectionView.backgroundView = activityIndicatorView
        fetchEstablishments()
        establishmentCollectionView.dataSource = self
        establishmentCollectionView.delegate = self
    }
    
    func fetchEstablishments() {
        var urlString = "https://developers.zomato.com/api/v2.1/establishments?city_id="
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
                            let establishmentNames = try jsonDecoder.decode(Establishments.self, from: data!)
                            if establishmentNames.establishments != nil {
                                self.establishments = establishmentNames.establishments
                            }
                            DispatchQueue.main.async(execute: {
                                self.activityIndicatorView.stopAnimating()
                                self.establishmentCollectionView.reloadData()
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
        return establishments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "establishmentCell",
                                                      for: indexPath) as! EstablishmentCollectionCell
        cell.establishmentName.text = establishments[indexPath.item].establishment.name
        cell.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        cell.tintColor = .white
        cell.cornerRadius = 8
        cell.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cell.setShadowColor(UIColor.black, for: .highlighted)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantListEstablishment") as? RestaurantListEstablishment
        viewController?.passedEstablishmentIdValue = establishments[indexPath.item].establishment.id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}

class EstablishmentCollectionCell: MDCCardCollectionCell {
    
    @IBOutlet weak var establishmentName: UILabel!
}
