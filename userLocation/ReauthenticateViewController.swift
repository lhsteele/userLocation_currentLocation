//
//  ReauthenticateViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/13/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import ChameleonFramework

class ReauthenticateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var reauthEmailTextField: UITextField!
    @IBOutlet var reauthPasswordTextField: UITextField!
    @IBOutlet var reauthSubmitButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        reauthEmailTextField.delegate = self
        reauthEmailTextField.returnKeyType = UIReturnKeyType.done
        
        reauthPasswordTextField.delegate = self
        reauthPasswordTextField.returnKeyType = UIReturnKeyType.done
        
        view.backgroundColor = FlatTeal()
        reauthSubmitButton.tintColor = FlatWhite()
        label.textColor = FlatWhite()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func reauthDeleteUser(_ sender: Any) {
        reauthenticateToDelete()
    }
    
    
    func reauthenticateToDelete() {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: reauthEmailTextField.text!, password: reauthPasswordTextField.text!)
        
        user?.reauthenticate(with: credential) { error in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "Unable to delete account due to re-authentication failure. Please try again.")
            } else {
                self.deleteAccount()
                self.deleteFromDB()
            }
        }
    }
    
    
    func deleteAccount () {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print (error)
            } else {
                self.displayAccountDeletedMessage(messageToDisplay: "Account has been successfully deleted.")
            }
        }
    }
    
    func deleteFromDB() {
        if let userToDeleteID = Auth.auth().currentUser?.uid {
            let deleteRef = Database.database().reference().child("Emails")
            let deleteFromEmailNode = deleteRef.child(userToDeleteID)
            deleteFromEmailNode.removeValue()

            let deleteRef2 = Database.database().reference().child("Users")
            let deleteFromUsersNode = deleteRef2.child(userToDeleteID)
            deleteFromUsersNode.removeValue()
        }
        
    }
    
    
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
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
    
    func displayReauthMessage(messageToDisplay: String) {
        let reauthAlertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.performSegue(withIdentifier: "ReauthenticationSegue", sender: self)
        }
        
        reauthAlertController.addAction(OKAction)
        
        self.present(reauthAlertController, animated: true, completion:nil)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reauthEmailTextField.resignFirstResponder()
        reauthPasswordTextField.resignFirstResponder()
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
