//
//  SignUp.swift
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

class SignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var email: MDCTextField!
    @IBOutlet weak var password: MDCTextField!
    
    @IBOutlet weak var lastName: MDCTextField!
    @IBOutlet weak var firstName: MDCTextField!
    @IBOutlet weak var signup: MDCButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: signup)
        signupLabel.textColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
        signup.backgroundColor = UIColor(red: 0, green: 0.67, blue: 0.55, alpha: 1)
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
    
    @IBAction func signUpButton(_ sender: MDCButton) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            if user != nil {
                self.saveProfile(firstName: self.firstName.text ?? "Null", lastName: self.lastName.text ?? "Null") { success in
                    if success {
                        self.displayAlertMessage(message: "User Created")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            } else {
                self.displayErrorMessage(message: "Error")
            }
        }
    }
    
    func saveProfile(firstName: String, lastName: String, completion: @escaping ((_ success: Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userDefaults = UserDefaults.standard
        userDefaults.set(uid, forKey: "User")
        let databaseReference = Database.database().reference().child("users/profile/\(uid)")
        let userObject = [
            "firstName": firstName,
            "lastName": lastName
        ] as [String: Any]
        databaseReference.setValue(userObject) {
            error, ref in
            completion(error == nil)
        }
    }
    
    func displayAlertMessage(message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Go To Login", comment: "Default action"), style: .`default`, handler: { _ in
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LogIn") as? LogIn
                self.navigationController?.pushViewController(viewController!, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func displayErrorMessage(message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
}
