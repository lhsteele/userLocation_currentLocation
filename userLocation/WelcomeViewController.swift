//
//  WelcomeViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/4/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseAuth
import ChameleonFramework

class WelcomeViewController: UIViewController, UIGestureRecognizerDelegate {

    var fireUserID = String()
    var userEmail = String()
    var username = String()
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.backgroundColor = FlatTeal()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getUserInfo() {
        let user = Auth.auth().currentUser
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
        
        if let _ = Auth.auth().currentUser {
            self.getUserInfo()
            print ("welcomeVC\(fireUserID)")  
            self.performSegue(withIdentifier: "UserLoggedInSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }

}
