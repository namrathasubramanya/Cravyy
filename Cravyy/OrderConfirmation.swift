//
//  OrderConfirmation.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/19/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MaterialComponents
import MaterialComponents.MaterialAppBar

class OrderConfirmation: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var confirmButton: MDCButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var delievry: UILabel!
    @IBOutlet weak var sum: UILabel!
    @IBOutlet weak var tax: UILabel!
    var dollarSign: String = "$"
    var sumValue: Double = 0.0
    var taxValue: Double = 0.0
    var deliveryFee: Double = 3.0
    var grandTotal: Double = 0.0
    var confirmedDishes: [String] = []
    var confirmedPrices: [String] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let doubleArray = confirmedPrices.map{ NSString(string: $0).doubleValue }
        sumValue = doubleArray.reduce(0, +)
        sum.text = "$" + String(format: "%.2f", sumValue)
        taxValue = 0.0725 * sumValue
        tax.text = "$" + String(format: "%.2f", taxValue)
        delievry.text = "$" + String(deliveryFee)
        grandTotal = sumValue + taxValue + deliveryFee
        total.text = "$" + String(format: "%.2f", grandTotal)
        let buttonScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: confirmButton)
        confirmButton.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return confirmedDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "confirmedCell", for: indexPath) as! ConfirmedOrderCell
        cell.name.text = confirmedDishes[indexPath.row]
        cell.name.numberOfLines = 0
        cell.price.text = "$" + confirmedPrices[indexPath.row]
        return cell
    }
    
    func displayAlertMessage(message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Log Out", comment: "Default action"), style: .`default`, handler: { _ in
                
                do{
                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                }catch{
                    print("Error while signing out!")
                }
            
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    @IBAction func confirm(_ sender: MDCButton) {
        displayAlertMessage(message: "Order Confirmed")
    }
    
}

class ConfirmedOrderCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
}
