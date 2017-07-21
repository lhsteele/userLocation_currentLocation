//
//  NewPasswordViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/5/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class NewPasswordViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet var label: UILabel!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        newPasswordTextField.delegate = self
        newPasswordTextField.returnKeyType = UIReturnKeyType.done
        
        view.backgroundColor = FlatTeal()
        submitButton.tintColor = FlatWhite()
        label.textColor = FlatWhite()
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
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    func appDidEnterBackground(_application: UIApplication) {
        try! FIRAuth.auth()!.signOut()
    }


}
