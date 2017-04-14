//
//  SettingsTableViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/14/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet var backButton: UIBarButtonItem!
    
    
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

    /*
     @IBAction func deleteAccount(_ sender: Any) {
     let user = FIRAuth.auth()?.currentUser
     
     user?.delete { error in
     if let error = error {
     self.displayReauthMessage(messageToDisplay: "Account must be re-authenticated to delete.")
     } else {
     self.performSegue(withIdentifier: "UserDeletedExitSegue", sender: self.deleteAccountButton)
     self.displayAccountDeletedMessage(messageToDisplay: "Account has been successfully deleted.")
     }
     }
     }
    
    
     func displayAccountDeletedMessage(messageToDisplay: String) {
     let deleteAlertController = UIAlertController(title: "Success", message: messageToDisplay, preferredStyle: .alert)
     
     let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
     }
     
     deleteAlertController.addAction(OKAction)
     
     self.present(deleteAlertController, animated: true, completion: nil)
     
     }
     
     func displayReauthMessage(messageToDisplay: String) {
     let reauthAlertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
     
     let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
     self.performSegue(withIdentifier: "ReauthenticationSegue", sender: self)
     }
     
     reauthAlertController.addAction(OKAction)
     
     self.present(reauthAlertController, animated: true, completion:nil)
     }
    */
    
    


}
