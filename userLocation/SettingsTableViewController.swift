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
}
