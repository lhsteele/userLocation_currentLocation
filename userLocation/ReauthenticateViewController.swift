//
//  ReauthenticateViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/13/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseAuth

class ReauthenticateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var reauthEmailTextField: UITextField!
    @IBOutlet var reauthPasswordTextField: UITextField!
    @IBOutlet var reauthSubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        reauthEmailTextField.delegate = self
        reauthEmailTextField.returnKeyType = UIReturnKeyType.done
        
        reauthPasswordTextField.delegate = self
        reauthPasswordTextField.returnKeyType = UIReturnKeyType.done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func reauthDeleteUser(_ sender: Any) {
        reauthenticateToDelete()
    }
    
    
    func reauthenticateToDelete() {
        let user = FIRAuth.auth()?.currentUser
        var credential = FIREmailPasswordAuthProvider.credential(withEmail: reauthEmailTextField.text!, password: reauthPasswordTextField.text!)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                print ("error")
                self.displayAlertMessage(messageToDisplay: "Unable to delete account due to re-authentication failure. Please try again.")
            } else {
                print ("reauthenticated")
                self.deleteAccount()
            }
        }
    }
    
    func deleteAccount () {
        let user = FIRAuth.auth()?.currentUser
        
        user?.delete { error in
            if let error = error {
                print (error)
            } else {
                self.displayAccountDeletedMessage(messageToDisplay: "Account has been successfully deleted.")
            }
        }
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            //print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func displayAccountDeletedMessage(messageToDisplay: String) {
        let deleteAlertController = UIAlertController(title: "Success", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "UserDeletedExitSegue", sender: self)
        }
        
        deleteAlertController.addAction(OKAction)
        
        self.present(deleteAlertController, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reauthEmailTextField.resignFirstResponder()
        reauthPasswordTextField.resignFirstResponder()
        return true
    }

}
