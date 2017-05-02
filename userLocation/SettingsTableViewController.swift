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
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        let firebaseAuth = FIRAuth.auth()
        
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        performSegue(withIdentifier: "LogoutSegue", sender: logoutButton)

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
