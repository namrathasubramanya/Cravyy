//
//  ViewController.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/2/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import MaterialComponents.MaterialButtons_ButtonThemer
import MaterialComponents.MaterialColorScheme
import MaterialComponents.MaterialNavigationBar_ColorThemer
let zomatoKey = "bc28bcb051ab50267edbbcc2da33fb5a"

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var loginButton: MDCButton!
    @IBOutlet weak var signupButton: MDCButton!
    @IBOutlet weak var logoText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigation = self.navigationController?.navigationBar
        navigation?.barStyle = UIBarStyle.black
        navigation?.tintColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        let userDefaults = UserDefaults.standard
        userDefaults.set("No", forKey: "LatLong")
        let buttonScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: loginButton)
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: signupButton)
        loginButton.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        signupButton.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        logoText.textColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
    }


}

