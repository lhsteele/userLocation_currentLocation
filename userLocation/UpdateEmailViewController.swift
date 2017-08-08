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
    
    
    @IBOutlet var label: UILabel!
    @IBOutlet var newEmailTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        
        newEmailTextField.delegate = self
        newEmailTextField.returnKeyType = UIReturnKeyType.done
        
        view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        submitButton.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        label.textColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitToUpdateEmail(_ sender: Any) {
        updateEmail()
    }
    
    func updateEmail() {
        let user = Auth.auth().currentUser
        user?.updateEmail(to: newEmailTextField.text!, completion: { (error) in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "There has been an error changing your email address. Please try again.")
            } else {
                self.updateUserEmailInDB()
                self.displaySucessAlertMessage(messageToDisplay: "Your email has been successfully updated. Please login with your new email address.")
            }
        })
    }
    
    func updateUserEmailInDB() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
            let destination = ref.child("Users").child(userID).key
            let updatedEmail = ["Email" : newEmailTextField.text]
            let childUpdates = ["/Users/\(destination)" : updatedEmail]
            ref.updateChildValues(childUpdates)
        }
        self.updateDBEmailList()
        
    }
    
    func updateDBEmailList() {
        if let newEmail = newEmailTextField.text {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
            if let userID = Auth.auth().currentUser?.uid {
                let updatedEmail = [userID : newEmail]
                
                ref.child("Emails").updateChildValues(updatedEmail) { (err, ref) in
                    if err != nil {
                        return
                    }
                }
            }
        }
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
