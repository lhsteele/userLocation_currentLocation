//
//  UpdateEmailReauthViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/5/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase

class UpdateEmailReauthViewController: UIViewController {

   
    @IBOutlet var reauthToUpdatePasswordTextField: UITextField!
    @IBOutlet var reauthToUpdateEmailTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reauthenticateToUpdateEmail() {
        let user = FIRAuth.auth()?.currentUser
        var credential = FIREmailPasswordAuthProvider.credential(withEmail: reauthToUpdateEmailTextField.text!, password: reauthToUpdatePasswordTextField.text!)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                self.displayAlertMessage(messageToDisplay: "Re-authentication failure. Please check credentials and try again.")
            } else {
                self.performSegue(withIdentifier: "UpdateEmailSeuge", sender: self.submitButton)
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

}
