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

    @IBOutlet var goButton: UIButton!
    var fireUserID = String()
    var userEmail = String()
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        let gestureRec = UITapGestureRecognizer(target: self, action: #selector (self.tapAction (_:)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

/*
    @IBAction func goToLogin(_ sender: Any) {
        
        
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
 */
    
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
        if (segue.identifier == "UserSignedInSegue") {
            
            let pointer = segue.destination as! FavoriteLocationsTableViewController
            
            pointer.fireUserID = self.fireUserID
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.getUserInfo()
                print (self.fireUserID)
                self.performSegue(withIdentifier: "UserSignedInSegue", sender: self)
            } else {
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        })
    }

}
