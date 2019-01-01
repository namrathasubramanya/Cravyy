//
//  LogIn.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/2/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import MaterialComponents
import MaterialComponents.MaterialAppBar
import MaterialComponents.MaterialTextFields

class LogIn: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var email: MDCTextField!
    @IBOutlet weak var password: MDCTextField!
    @IBOutlet weak var login: MDCButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: login)
        login.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        loginLabel.textColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        password.isSecureTextEntry = true
    }
    
    func textFieldShouldReturn(textField: MDCTextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @IBAction func loginButton(_ sender: MDCButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) {(authResult,error) in 
            switch error {
            case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                self.displayAlertMessage(message: "Wrong password!")
            case .some(let error):
                self.displayAlertMessage(message: "Login error: \(error.localizedDescription)")
            case .none:
                if let user = authResult?.user {
                    print(user.uid)
                    self.performSegue(withIdentifier: "Login", sender: self)
                }
            }
        }
    }
    
    
    func displayAlertMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
