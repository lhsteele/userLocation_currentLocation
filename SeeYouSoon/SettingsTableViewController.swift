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


    @IBOutlet var updateEmailButton: UITableViewCell!
    @IBOutlet var changePasswordButton: UITableViewCell!
    @IBOutlet var logoutButton: UITableViewCell!
    @IBOutlet var deleteAccountButton: UITableViewCell!
    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        
        updateEmailButton.textLabel?.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        changePasswordButton.textLabel?.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        logoutButton.textLabel?.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        deleteAccountButton.textLabel?.textColor = UIColor(red: 0.75, green: 0.22, blue: 0.16, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
