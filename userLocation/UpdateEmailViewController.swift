//
//  UpdateEmailViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/5/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase

class UpdateEmailViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var newEmailTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var handle: FIRAuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        newEmailTextField.delegate = self
        newEmailTextField.returnKeyType = UIReturnKeyType.done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitToUpdateEmail(_ sender: Any) {
        updateEmail()
    }
    
    func updateEmail() {
        let user = FIRAuth.auth()?.currentUser
        user?.updateEmail(newEmailTextField.text!, completion: { (error) in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "There has been an error changing your email address. Please try again.")
            } else {
                self.displaySucessAlertMessage(messageToDisplay: "Your email has been successfully updated. Please login with your new email address.")
            }
        })
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displaySucessAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Success", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "emailUpdatedReturnToLoginSegue", sender: self)
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newEmailTextField.resignFirstResponder()
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
