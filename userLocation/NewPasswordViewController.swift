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
    
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitToChangePassword(_ sender: Any) {
        changePassword()
    }
    
    func changePassword() {
        let user = FIRAuth.auth()?.currentUser
        user?.updatePassword(newPasswordTextField.text!, completion: { (error) in
            if let error = error {
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


}
