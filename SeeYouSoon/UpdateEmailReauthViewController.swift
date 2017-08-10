//
//  UpdateEmailReauthViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/5/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase

class UpdateEmailReauthViewController: UIViewController, UITextFieldDelegate {

   
    @IBOutlet var label: UILabel!
    @IBOutlet var reauthToUpdatePasswordTextField: UITextField!
    @IBOutlet var reauthToUpdateEmailTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        
        reauthToUpdateEmailTextField.delegate = self
        reauthToUpdateEmailTextField.returnKeyType = UIReturnKeyType.done
        
        reauthToUpdatePasswordTextField.delegate = self
        reauthToUpdatePasswordTextField.returnKeyType = UIReturnKeyType.done
      
        view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        submitButton.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        label.textColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func reauthToUpdateEmail(_ sender: Any) {
        reauthenticateToUpdateEmail()
    }
    
    
    
    func reauthenticateToUpdateEmail() {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: reauthToUpdateEmailTextField.text!, password: reauthToUpdatePasswordTextField.text!)
        
        user?.reauthenticate(with: credential) { error in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "Re-authentication failure. Please check credentials and try again.")
            } else {
                self.performSegue(withIdentifier: "UpdateEmailSegue", sender: self.submitButton)
                
            }
        }
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reauthToUpdateEmailTextField.resignFirstResponder()
        reauthToUpdatePasswordTextField.resignFirstResponder()
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