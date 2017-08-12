//
//  NewPasswordViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/5/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase


class NewPasswordViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet var label: UILabel!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        
        newPasswordTextField.delegate = self
        newPasswordTextField.returnKeyType = UIReturnKeyType.done
        
        view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        submitButton.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        submitButton.layer.borderColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0).cgColor
        submitButton.layer.borderWidth = 1
        submitButton.layer.cornerRadius = 10
        label.textColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func submitToChangePassword(_ sender: Any) {
        changePassword()
    }
    
    func changePassword() {
        let user = Auth.auth().currentUser
        user?.updatePassword(to: newPasswordTextField.text!, completion: { (error) in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "There has been an error updating your password. Please try again.")
            } else {
                self.displaySuccessAlertMessage(messageToDisplay: "Your password has been successfully changed. Please login with your new password.")
            }
        })
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func displaySuccessAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Success", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.performSegue(withIdentifier: "PasswordChangedLoginSegue", sender: self)
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newPasswordTextField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func appDidEnterBackground(_application: UIApplication) {
        try! Auth.auth().signOut()
    }


}
