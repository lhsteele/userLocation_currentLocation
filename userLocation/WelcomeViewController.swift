//
//  WelcomeViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/4/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController, UIGestureRecognizerDelegate {

    var fireUserID = String()
    var userEmail = String()
    var username = String()
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getUserInfo() {
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let uid =  user.uid
            let email = user.email!
            fireUserID = uid
            userEmail = email
            
            if let displayName = user.displayName {
                username = displayName
            }
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "UserLoggedInSegue") {
            
            let pointer = segue.destination as! FavoriteLocationsTableViewController
            
            pointer.fireUserID = self.fireUserID
            
        }
        print ("logged in\(self.fireUserID)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.getUserInfo()
                self.performSegue(withIdentifier: "UserLoggedInSegue", sender: self)
            } else {
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        })
        
    }

}
