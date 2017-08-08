//
//  ShareLocationViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/27/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ShareLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var shareLocEmailTextField: UITextField!
    @IBOutlet var shareLocSubmitButton: UIButton!
    
    var emailToCheck = String()
    var locationToShare = String()
    var fireUserID = String()
    var sharedEmailsUserID = String()
    var username = String()
    var sharedLocKey = String()
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        shareLocEmailTextField.delegate = self
        shareLocEmailTextField.returnKeyType = UIReturnKeyType.done

        view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        shareLocSubmitButton.setTitleColor(UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0), for: UIControlState.normal)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        label.textColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func shareLocation(_ sender: Any) {
        emailToCheck = shareLocEmailTextField.text!
        
        let validEmail = isEmailValid(emailAddressString: emailToCheck)
        
        
        if validEmail {
            let registeredUserRef = Database.database().reference().child("Emails")
            
            registeredUserRef.queryOrderedByKey().observe(.value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    let listOfEmails = snapshot.children
                    
                    var emailFound = false
                    
                    for snap in listOfEmails {
                        if let email = snap as? DataSnapshot {
                            if let userEmail = email.value as? String {
                                if userEmail == self.emailToCheck {
                                    emailFound = true
                                    self.findEmailsUserID()
                                }
                            }
                        }
                    }
                    if !emailFound {
                        self.displayErrorAlertMessage(messageToDisplay: "This is not a registered email address. Would you like to share the app?")
                    }
                }
                
            })
        } else {
            displayErrorAlertMessage(messageToDisplay: "This email address is invalid or already in use.")
            return
        }
        
    }
    
    func findEmailsUserID() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        ref.child("Emails").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                
                let listOfEmails = snapshot.children
                for snap in listOfEmails {
                    if let email = snap as? DataSnapshot {
                        if let userEmail = email.value as? String {
                            let userKey = email.key
                            if userEmail == self.emailToCheck {
                                self.sharedEmailsUserID = userKey
                                self.checkIfLocationAlreadySharedWithUser()
                            }
                        }
                    }
                }
            }
        })
        
    }
    
    func checkIfLocationAlreadySharedWithUser() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("SubscribedUsers").queryOrderedByKey()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children
            for item in items {
                if let locationID = item as? DataSnapshot {
                    let locIDKey = locationID.key 
                        if locIDKey == self.locationToShare {
                            if let userID = item as? DataSnapshot {
                                
                                for item2 in userID.children {
                                    if let pair = item2 as? DataSnapshot {
                                        
                                        if let ID = pair.value as? String {
                                            
                                            
                                            if ID == self.sharedEmailsUserID {
                                                self.displayEmailExistsErrorAlertMessage(messageToDisplay: "Location has already been shared with this user.")
                                                return
                                            }
                                        }
                                    }
                                }
                                self.findEmailsUsername()
                                
                            }
                        } else {
                            self.findEmailsUsername()
                        }
                }
                
            }
            self.shareLocWithUser()
        })
    }
    
    func shareLocWithUser() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("LocationsSharedWithUser").child(sharedEmailsUserID)
        sharedLocKey = ref.childByAutoId().key
        let updates = [sharedLocKey : locationToShare]
        ref.updateChildValues(updates)
        self.displaySuccessAlertMessage(messageToDisplay: "This location will be shared with \(self.emailToCheck)")
    }
    
    
    func findEmailsUsername() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        ref.child("Usernames").queryOrderedByKey().observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                
                var usernameToShare = String()
                
                let listOfUserIDs = snapshot.children
                
                for snap in listOfUserIDs {
                    if let displayName = snap as? DataSnapshot {
                        
                        let userID = displayName.key as String
                            if userID == self.sharedEmailsUserID {
                                if let usersName = displayName.value as? String {
                                    usernameToShare = usersName
                                    self.saveSubscribedUserToLoc(username: usernameToShare)
                                    return
                                }
                            }
                    }
                    
                }
            }
        })
    }
    
    func saveSubscribedUserToLoc(username: String) {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        let saveRef = ref.child("SubscribedUsers").child(locationToShare)
        let updates = [username : sharedEmailsUserID]
        saveRef.updateChildValues(updates)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BackToFavorites") {
            let pointer = segue.destination as! FavoriteLocationsTableViewController
            pointer.sharedLocKey = self.sharedLocKey
            pointer.sharedEmailsUserID = self.sharedEmailsUserID
        }
    }

    func displaySuccessAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Success", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.performSegue(withIdentifier: "BackToFavorites", sender: self)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func displayErrorAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(cancelAction)
        
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action:UIAlertAction) in
            let activityVC = UIActivityViewController(activityItems: ["input app store address here?"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
        }
        alertController.addAction(shareAction)
        
        self.present(alertController, animated: true, completion:nil)
    }

    func displayEmailExistsErrorAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let cancelShareAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) in
            self.performSegue(withIdentifier: "BackToFavorites", sender: self)
        }
        alertController.addAction(cancelShareAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func isEmailValid(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch _ as NSError {
            returnValue = false
        }
        
        return  returnValue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.shareLocEmailTextField {
            self.shareLocEmailTextField.text = textField.text!
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shareLocEmailTextField.resignFirstResponder()
        
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
