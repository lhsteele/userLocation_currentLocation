//
//  ShareLocationViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/27/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ShareLocationViewController: UIViewController {
    
    @IBOutlet var shareLocEmailTextField: UITextField!
    @IBOutlet var shareLocSubmitButton: UIButton!
    
    var emailToCheck = String()
    var locationToShare = String()
    var fireUserID = String()
    var sharedEmailsUserID = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print ("ShareLocVC\(locationToShare)")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func shareLocation(_ sender: Any) {
        emailToCheck = shareLocEmailTextField.text!
        findEmailsUserID()
        
        let validEmail = isEmailValid(emailAddressString: emailToCheck)
        
        
        if validEmail {
            print ("validEmail")
        } else {
            displayErrorAlertMessage(messageToDisplay: "This email address is invalid or already in use.")
            return
        }
        
        let registeredUserRef = FIRDatabase.database().reference().child("Emails")
        
        registeredUserRef.queryOrderedByKey().observe(.value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                //print (snapshot)
                let listOfEmails = snapshot.children
                
                var emailFound = false
                
                for snap in listOfEmails {
                    if let email = snap as? FIRDataSnapshot {
                        if let userEmail = email.value as? String {
                            print (userEmail)
                            print (self.emailToCheck)
                            if userEmail == self.emailToCheck {
                                self.displaySuccessAlertMessage(messageToDisplay: "This location will be shared with \(self.emailToCheck)")
                                emailFound = true
                            }
                        }
                    }
                }
                if !emailFound {
                    self.displayErrorAlertMessage(messageToDisplay: "This is not a registered email address. Would you like to share the app?")
                }
            }
            
        })
    }
    
    func shareLocWithUser() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        let shareRef = ref.child("SharedLocations").child(sharedEmailsUserID)
        let updates = [shareRef.childByAutoId().key : locationToShare]
        shareRef.updateChildValues(updates)
    }
    
    func findEmailsUserID() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        ref.child("Emails").queryOrderedByKey().observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                
                let listOfEmails = snapshot.children
                for snap in listOfEmails {
                    if let email = snap as? FIRDataSnapshot {
                        if let userEmail = email.value as? String, let userKey = email.key as? String {
                            if userEmail == self.emailToCheck {
                            self.sharedEmailsUserID = userKey
                            //print (self.sharedEmailsUserID)
                            self.shareLocWithUser()
                            return
                            }
                        }
                    }
                }
                print ("emailNotFound")
            }
        })
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
            print ("share button tapped")
            let activityVC = UIActivityViewController(activityItems: ["input app store address here?"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
        }
        alertController.addAction(shareAction)
        
        self.present(alertController, animated: true, completion:nil)
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
            //print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }

}
