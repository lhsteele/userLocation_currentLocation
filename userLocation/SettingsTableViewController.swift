//
//  SettingsTableViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/14/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseAuth
import ChameleonFramework

class SettingsTableViewController: UITableViewController {
    
    var userEmail = String()
    var userPassword = String()
    var fireUserID = String()


    @IBOutlet var updateEmailButton: UITableViewCell!
    @IBOutlet var changePasswordButton: UITableViewCell!
    @IBOutlet var logoutButton: UITableViewCell!
    @IBOutlet var deleteAccountButton: UITableViewCell!
    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = FlatWhite()
        
        updateEmailButton.textLabel?.textColor = FlatTeal()
        changePasswordButton.textLabel?.textColor = FlatTeal()
        logoutButton.textLabel?.textColor = FlatTeal()
        deleteAccountButton.textLabel?.textColor = FlatRedDark()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //indexPath data type has two values, section and row 
        //use a switch case statement to assign a function to each case/index number.
        switch indexPath.row {
        case 0:
            print("not working")
            performSegue(withIdentifier: "ReauthToUpdateEmailSegue", sender: updateEmailButton)
        case 1:
            performSegue(withIdentifier: "ReauthToChangePasswordSegue", sender: changePasswordButton)
        case 2:
            let firebaseAuth = Auth.auth()
            
            do {
                try firebaseAuth.signOut()
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
