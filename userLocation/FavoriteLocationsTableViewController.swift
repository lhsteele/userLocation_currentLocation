 //
//  favoriteLocationsTableViewController.swift
//  userLocation
//
//  Created by Lisa H Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Firebase

let favoriteLocationKey = "NewFavoriteLocation"

class FavoriteLocationsTableViewController: UITableViewController, CLLocationManagerDelegate, UITabBarDelegate, UINavigationBarDelegate {
    
    var listOfFavorites: [SavedFavorites] = []
    var username = ""
    //var databaseHandle: FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    var handle: FIRAuthStateDidChangeListenerHandle?
    var fireUserID = String()
    var latCoordPassed = CLLocationDegrees()
    var longCoordPassed = CLLocationDegrees()
    
    
    
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var deleteAccountButton: UIButton!
    
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        print ("view did load")
        loadData()
        print ("favorites\(fireUserID)")
    }
    
    
    func loadData () {
        let databaseRef = FIRDatabase.database().reference().child("Locations")
        username = "Lisa"
    
        _ = databaseRef.observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                var updatedLocation = ""
                var updatedLat = Double()
                var updatedLong = Double()
                
                if let dbLocation = item as? FIRDataSnapshot {
                    
                    for item2 in dbLocation.children {
                        
                        if let pair = item2 as? FIRDataSnapshot {
                            
                            //'always suceeds' error means an unnecessary level of casting.
                            
                            if let location = pair.value as? String {
                                
                                updatedLocation = location
                                
                            } else {
                                
                                if let value = pair.value as? Double {
                                    
                                    let valueName = pair.key
                                    
                                    if valueName == "Latitude" {
                                        updatedLat = value
                                    } else {
                                        updatedLong = value
                                    }
                                }
                            }
                        }
                    }
                }
                let newFavorite = SavedFavorites(latCoord: updatedLat, longCoord: updatedLong, location: updatedLocation, userID: self.fireUserID)
                self.listOfFavorites.append(newFavorite)
            }
            self.tableView.reloadData()
        })
        createUsersArray()
    }
    
    func createUsersArray () {
        let databaseRef2 = FIRDatabase.database().reference().child("Locations")
        
        _ = databaseRef2.observe(.childAdded, with: { snapshot in
            var subscribedUser = FIRDataSnapshot()
            var updatedUserArray = [FIRDataSnapshot]()
            
            for item in snapshot.children {
                
                if let user = item as? FIRDataSnapshot {
                    
                    for item2 in user.children {
                        
                        if let userID = item2 as? FIRDataSnapshot {
                            subscribedUser = userID
                        }
                        updatedUserArray.append(subscribedUser)
                    }
                }
            }
            
            print(updatedUserArray)
        })
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let favorite = self.listOfFavorites[indexPath.row]
    
        cell.textLabel?.text = favorite.location
        
        return cell
  
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.listOfFavorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        tableView.reloadData()
    }
    
    
    @IBAction func logoutUser(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        performSegue(withIdentifier: "LogoutSegue", sender: logoutButton)
    }
    
    @IBAction func addNewLocation(_ sender: Any) {
        performSegue(withIdentifier: "MapViewSegue", sender: addButton)
        
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        let user = FIRAuth.auth()?.currentUser
        
        user?.delete(completion: { (error) in
            if error != nil {
                self.displayReauthMessage(messageToDisplay: "Account must be re-authenticated to delete.")
                self.reauthenticateToDelete()
            } else {
                self.displayAccountDeletedMessage(messageToDisplay: "Account has been successfully deleted.")
            }
        })
    }
 
    func reauthenticateToDelete() {
        let user = FIRAuth.auth()?.currentUser
        var credential: FIRAuthCredential?
    
        user?.reauthenticate(with: credential!) { error in
            if let error = error {
                self.displayAlertMessage(messageToDisplay: "Unable to delete account due to re-authentication failure. Please try again.")
            } else {
                self.displayAccountDeletedMessage(messageToDisplay: "Account has been successfully deleted.")
            }
        }
    }
 
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            //print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func displayAccountDeletedMessage(messageToDisplay: String) {
        let deleteAlertController = UIAlertController(title: "Success", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "LogoutSegue", sender: self.deleteAccountButton)
        }
        
        deleteAlertController.addAction(OKAction)
        
        self.present(deleteAlertController, animated: true, completion: nil)
        
    }
    
    func displayReauthMessage(messageToDisplay: String) {
        let reauthAlertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.performSegue(withIdentifier: "LogoutSegue", sender: self)
        }
        
        reauthAlertController.addAction(OKAction)
        
        self.present(reauthAlertController, animated: true, completion:nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MapViewSegue") {
            let pointer = segue.destination as! ViewController
            pointer.fireUserID = self.fireUserID
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print ("view did appear")
        //createUsersArray()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        }
        print("view will appear")
        //loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfFavorites.count
    }
    
    func toggleEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let favoriteMoving = listOfFavorites.remove(at: fromIndexPath.row)
        listOfFavorites.insert(favoriteMoving, at: to.row)
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }
    
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
