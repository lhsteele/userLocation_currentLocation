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
    var listOfCreatedLocations = [String]()
    var locationID = ""
    var username = ""
    var ref: FIRDatabaseReference?
    var handle: FIRAuthStateDidChangeListenerHandle?
    var fireUserID = String()
    var latCoordPassed = CLLocationDegrees()
    var longCoordPassed = CLLocationDegrees()
    var userEmail = String()
    var userPassword = String()
    var currentUserFavoritesArray = [String]()
    var favoriteLocations = String()
    var locationIDDictionary: [String:String] = [:]
    
    
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet var addLocationButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        addLocationButton.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 0/255, alpha: 1).cgColor
        addLocationButton.layer.borderWidth = 3
        addLocationButton.layer.cornerRadius = 10
        
        
        loadFavorites()
        
    }
    
    func loadFavorites() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            
            let locationKey = ref.child("Users").child(userID).child("CreatedLocations")
            locationKey.observe(.value, with: { (snapshot) in
                
                
                let createdLocations = snapshot.children
                    
                    for item in createdLocations {
                    
                        if let pair = item as? FIRDataSnapshot {
                            if let locID = pair.value as? String {
                                self.locationID = locID
                            }
                        }
                        
                        self.listOfCreatedLocations.append(self.locationID)

                    }
                //Here I'm trying to create a dictionary to which I can refer later, when trying to delete an entry. However, this data only lives within this closure.
                self.locationIDDictionary[userID] = self.locationID
                
                self.loadData()
            })
            //If I try to print the dictionary here, it just gives me an empty dictionary.
            print (self.locationIDDictionary)
        }
        
    }
    
    
    func loadData () {
        for item in listOfCreatedLocations {
            
            let databaseRef = FIRDatabase.database().reference().child("Locations").queryOrderedByKey()
            _ = databaseRef.queryEqual(toValue: item).observe(.value, with: { (snapshot) in
                
                for item2 in snapshot.children {
                    
                    var updatedLocation = ""
                    var updatedLat = Double()
                    var updatedLong = Double()
                    
                    if let dbLocation = item2 as? FIRDataSnapshot {
                        
                        for item2 in dbLocation.children {
                            
                            if let pair = item2 as? FIRDataSnapshot {
                                
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
        }
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
            
        })
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let favorite = self.listOfFavorites[indexPath.row]
    
        cell.textLabel?.text = favorite.location
        
        return cell
  
    }
   
    /*
    func deleteFromFirebase() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let deletionRef = FIRDatabase.database().reference().child("Users").child(uid).child("CreatedLocations")
        deletionRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
            deletionRef.removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print ("Failed to delete message", error)
                    return
                }
            })
        })
    }
    */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            
            self.listOfFavorites.remove(at: indexPath.row)
            
            let userFavToDelete = listOfCreatedLocations[indexPath.row] as String
            
            let deletionRef = FIRDatabase.database().reference().child("Users").child(uid).child("CreatedLocations")
            let keyToDelete = deletionRef.queryEqual(toValue: userFavToDelete)
            print (keyToDelete)
            
            deletionRef.child(byAppendingPath: ("Users/\(uid)/\CreatedLocations/\(keyToDelete)").removeValue()
            
            /*
            let keyToDelete = userFavToDelete
            let deletionRef = FIRDatabase.database().reference().child("Users").child(uid).child("CreatedLocations")
            deletionRef.queryEqual(toValue: userFavToDelete).observe(.value, with: { (snapshot) in
                print (snapshot)
            })
  */
            
            
            
            /*
            deletionRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for item in snapshot.children {
                        if (item as AnyObject).value as String == use›rFavToDelete {
                            (item as AnyObject).key.parent?.removeValue()
                        }
                        
                    }
                }
            })
            */
            
            /*
            ref.child(deletionRef).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print ("There has been an error")
                }
            })
            */
                /*
                deletionRef.queryEqual(toValue: userFavToDelete).removeValue(completionBlock: { (error, ref) in
                        if error != nil {
                            print ("There has been an error")
                        }
                })
                */
            
            /*
            let userFavToDelete = listOfCreatedLocations[indexPath.row]
            print (userFavToDelete)
            let deletionRef = FIRDatabase.database().reference().child("Users").child(uid).child("CreatedLocations").(userFavToDelete).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print ("Was not able to delete entry")
                    return
                }
            })
            */
            
            self.listOfCreatedLocations.remove(at: indexPath.row)
           
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
        performSegue(withIdentifier: "MapViewSegue", sender: addLocationButton)
        print (fireUserID)
    }
    
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "SettingsSegue", sender: settingsButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MapViewSegue") {
            let pointer = segue.destination as! ViewController
            pointer.fireUserID = self.fireUserID
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadData()
        //loadLocationKeys()
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        }
        
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
