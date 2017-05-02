//
//  SettingsTableViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/14/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {
    
    var userEmail = String()
    var userPassword = String()
    var fireUserID = String()

    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var logoutButton: UITableViewCell!
    @IBOutlet var deleteAccountButton: UITableViewCell!
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToFavorites(_ sender: Any) {
        performSegue(withIdentifier: "BackToFavorites", sender: backButton)
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //indexPath data type has two values, section and row 
        //use a switch case statement to assign a function to each case/index number.
        switch indexPath.row {
        case 0:
            print("no case yet")
        case 1:
            print("no case yet")
        case 2:
            let firebaseAuth = FIRAuth.auth()
            
            do {
                try firebaseAuth?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            performSegue(withIdentifier: "LogoutSegue", sender: logoutButton)
        case 3:
            performSegue(withIdentifier: "ReauthenticateSegue", sender: deleteAccountButton)
        default:
            ()
        }
        
        

    }
    
    func updateEmail() {
        let currentUser = FIRAuth.auth()?.currentUser
        
        currentUser?.updateEmail(userEmail, completion: { (error) in
            if let error = error {
                print (error)
            } //else {
                //currentUser?.updatePassword(self.userPassword, completion: { (error) in
                    //if let error = error {
                        
                    //} else {
                        print ("Sucess")
                    //}
                //})
            //}
        })
    }
    
    /*
    func changePassword() {
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: <#T##String#>, password: <#T##String#>)
    }
    */
}
