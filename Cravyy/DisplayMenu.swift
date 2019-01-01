//
//  DisplayMenu.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/19/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import MaterialComponents.MaterialAppBar

class DisplayMenu: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var placeOrderButton: MDCButton!
    @IBOutlet weak var menuView: UITableView!
    var cartDish: [String] = []
    var cartPrice: [String] = []
    var dishAndPrice: Dictionary<String, Array<String>>?
    var dishes: Array<String>?
    var dishNames: Array<String>?
    var prices: Array<String>?
    var cartCount: Int! = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "Menu", ofType: "plist")
        if path != nil {
            dishAndPrice = NSDictionary.init(contentsOfFile: path!) as? Dictionary<String, Array<String>>
            dishes = dishAndPrice?.keys.sorted()
        }
        menuView.allowsMultipleSelection = true
        menuView.delegate = self
        menuView.dataSource = self
        let buttonScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: placeOrderButton)
        placeOrderButton.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dishes?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableCell
        dishNames = dishAndPrice![dishes![indexPath.row]]
        cell.dishName.text = dishNames?[0]
        cell.dishPrice.text = "$" + (dishNames?[1])!
        cell.dishName.numberOfLines = 0
        cell.dishPrice.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cartCount += 1
        dishNames = dishAndPrice![dishes![indexPath.row]]
        cartDish.append((dishNames?[0])!)
        cartPrice.append((dishNames?[1])!)
        self.displayAlertMessage(message: "\(String(describing: dishNames![0])) added to cart")
    }
    
    
    @IBAction func placeOrder(_ sender: MDCButton) {
        if(cartCount == 0) {
            self.displayAlertMessage(message: "Your cart is empty")
        } else {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "OrderConfirmation") as? OrderConfirmation
            viewController?.confirmedDishes = cartDish
            viewController?.confirmedPrices = cartPrice
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    
    func displayAlertMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

class MenuTableCell: UITableViewCell {
    
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishName: UILabel!
}
