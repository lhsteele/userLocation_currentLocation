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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("ShareLocVC\(locationToShare)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareLocation(_ sender: Any) {
        emailToCheck = shareLocEmailTextField.text!
        print (emailToCheck)
        let registeredUserRef = FIRDatabase.database().reference()
        registeredUserRef.child("Users").queryOrderedByKey().child("Email").queryEqual(toValue: emailToCheck).observeSingleEvent(of: .value, with: { (snapshot) in
            let emails = snapshot.children
            print (snapshot)
            
            for item in emails {
                if let item2 = item as? FIRDataSnapshot {
                    if let email = item2.value as? String {
                        print (email)

                    }
                }
            }
            
        })
        
        //let userFound = registeredUserRef.queryOrderedByKey().queryEqual(toValue: emailToCheck)
        //if userFound
        
        /*
        let addRef = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        if userFound != nil {
            let locationKey = addRef.child("SharedLocations").child(emailToCheck).child("Location")
            let updates = [locationKey.child("Location") : locationToShare]
            locationKey.updateChildValues(updates)
        }
        */
    }
    

}

/*
func addLocToUser() {
    let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let locationKey = ref.child("Users").child(userID).child("CreatedLocations")
        let updates = [locationKey.childByAutoId().key : locationAutoKey]
        locationKey.updateChildValues(updates)
    }
    
}
 */
