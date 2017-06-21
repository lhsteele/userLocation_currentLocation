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

class FavoriteLocationsTableViewController: UITableViewController, CLLocationManagerDelegate, UINavigationBarDelegate {
    
    var listOfFavorites: [SavedFavorites] = []
    var listOfCreatedLocations = [String]()
    var listOfSharedFavorites: [SavedFavorites] = []
    var listOfSharedLocations = [String]()
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
    var userFavToDelete = String()
    var sharedFavToDelete = String()
    var locationToShare = String()
    var locationNameString = String()
    var journeyToStart = String()
    
    
    
    @IBOutlet var journeysButton: UIBarButtonItem!
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet var addLocationButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        addLocationButton.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 0/255, alpha: 1).cgColor
        addLocationButton.layer.borderWidth = 3
        addLocationButton.layer.cornerRadius = 10
        
        loadFavorites()
        
        self.deleteFromUsersCreatedLocations()
        
    }
    //When deleting a location from db, need to delete from Users as well as Location.
    
    func loadFavorites() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            
            let locationKey = ref.child("Users").child(userID).child("CreatedLocations")
            
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                let createdLocations = snapshot.children
                
                for item in createdLocations {
                    
                    if let pair = item as? FIRDataSnapshot {
                        if let locID = pair.value as? String {
                            self.locationID = locID
                        }
                    }
                    
                    self.listOfCreatedLocations.append(self.locationID)
                    
                }
                self.loadData()
            })
            
        }
        self.loadSharedLocations()
    }
    
    func loadSharedLocations() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            
            let locationKey = ref.child("LocationsSharedWithUser").child(userID)
            
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let sharedLocations = snapshot.children
                
                for item in sharedLocations {
                    if let pair = item as? FIRDataSnapshot {
                        if let locID = pair.value as? String {
                            self.locationID = locID
                            
                        }
                    }
                    self.listOfSharedLocations.append(self.locationID)
                }
                self.loadSharedData()
            })
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
    
    func loadSharedData () {
        
        for item in listOfSharedLocations {
            
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
                    self.listOfSharedFavorites.append(newFavorite)
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
        if indexPath.section == 0 {
            let favorite = self.listOfFavorites[indexPath.row]
            cell.textLabel?.text = favorite.location
        } else {
            let sharedFavorite = self.listOfSharedFavorites[indexPath.row]
            cell.textLabel?.text = sharedFavorite.location
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
            self.locationToShare = self.listOfFavorites[indexPath.row].location as String
            print (indexPath.row)
            print (self.listOfFavorites)
            print (self.listOfCreatedLocations)
            self.performSegue(withIdentifier: "ShareLocationSegue", sender: Any.self)
        }
        
        share.backgroundColor = UIColor.darkGray
        
        let startJourney = UITableViewRowAction(style: .normal, title: "Start Journey") { (action, indexPath) in
            self.journeyToStart = self.listOfFavorites[indexPath.row].location as String
            self.performSegue(withIdentifier: "StartJourneySegue", sender: Any.self)
        }
        
        // needs to be a separate delete to delete from each array.
        let deleteS0 = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            
                print (self.listOfFavorites.count)
                print (self.listOfSharedLocations.count)
                
                self.listOfFavorites.remove(at: indexPath.row)
                self.listOfCreatedLocations.remove(at: indexPath.row)
            
                self.tableView.reloadData()
                
                self.userFavToDelete = self.listOfFavorites[indexPath.row].location as String
            
                self.deleteFromLocationsDB()
                self.deleteFromSubscribedUsers()
            
            
                print (self.listOfFavorites.count)
                print (self.listOfSharedLocations.count)
            
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        
        // needs to be a separate delete to delete from each array.
        let deleteS1 = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            
            //self.listOfSharedFavorites.remove(at: indexPath.row)
            
            self.tableView.reloadData()
            
            //self.sharedFavToDelete = self.listOfSharedLocations[indexPath.row] as String
            
            //let sharedDeletionRef = FIRDatabase.database().reference().child("SharedLocations").child(uid)
            
            // any deletion from database should happen in function outside of this.
            
            /*
             sharedDeletionRef.observeSingleEvent(of: .value, with: { (snapshot) in
             for snap in snapshot.children {
             let keySnap = snap as! FIRDataSnapshot
             if keySnap.value as! String == self.sharedFavToDelete {
             keySnap.ref.removeValue()
             }
             }
             })
             */
            
            self.deleteFromLocationsDB()
            self.deleteFromSubscribedUsers()
            
            //self.listOfSharedLocations.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        if indexPath.section == 0 {
            return [share, startJourney, deleteS0]
        }
        return [deleteS1]
    }
    
    
    func deleteFromLocationsDB() {
        let locDeletionRef = FIRDatabase.database().reference().child("Locations")
        
        let locToDeleteRef = locDeletionRef.child(userFavToDelete)
        locToDeleteRef.removeValue()
        print ("deleteFromLocations run")
    }
    
    /*
    func deleteFromSharedLocations() {
        let sharedLocDeletionRef = FIRDatabase.database().reference().child("SharedLocations")
        sharedLocDeletionRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let keys = snapshot.children
    
            for item in keys {
                if let location = item as? FIRDataSnapshot {
                
                    for item2 in location.children {
                        if let pair = item2 as? FIRDataSnapshot {
                            
                            if let locId = pair.value as? String {
                                
                                if locId == "KjumHao0vttkv3l8nDx" {
                                    print ("locID match \(locId)")
                                }
                            }
                        }
                    }
                }
            }
            
        })
        
    }
    */
    
    func deleteFromSubscribedUsers() {
        let subscribedUsersDeletionRef = FIRDatabase.database().reference().child("SubscribedUsers")
        
        let locToDeleteRef = subscribedUsersDeletionRef.child(userFavToDelete)
        locToDeleteRef.removeValue()
        print ("deleteFromSubscribedUsers run")
    }
    
    func deleteFromUsersCreatedLocations() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            let deletionRef = FIRDatabase.database().reference().child("Users").child(uid).child("CreatedLocations")
            
            deletionRef.observeSingleEvent(of: .value, with: { (snapshot) in
                for snap in snapshot.children {
                    let keySnap = snap as? FIRDataSnapshot
                    print (keySnap)
                    if let value = keySnap?.value as? String {
                        let key = keySnap.key
                        if value == "KnBJo70wFt74z5ntxIG" {
                        
                        }
                    }
                }
            })
        }
    
        print ("deleteFromUsersCreatedLocations run")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            let indexPath = tableView.indexPathForSelectedRow!
            _ = tableView.cellForRow(at: indexPath)! as UITableViewCell
            performSegue(withIdentifier: "FavLocMapViewSegue", sender: self)
        } else {
            let indexPath = tableView.indexPathForSelectedRow!
            _ = tableView.cellForRow(at: indexPath)! as UITableViewCell
            performSegue(withIdentifier: "ShowSharedLocationSegue", sender: self)
        }
        
        
        
    }
    
    @IBAction func addNewLocation(_ sender: Any) {
        performSegue(withIdentifier: "MapViewSegue", sender: addLocationButton)
        print (fireUserID)
    }
    
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "SettingsSegue", sender: settingsButton)
    }
    
    
    @IBAction func goToLiveJourneys(_ sender: Any) {
        performSegue(withIdentifier: "liveJourneysSegue", sender: journeysButton)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MapViewSegue") {
            let pointer = segue.destination as! ViewController
            pointer.fireUserID = self.fireUserID
        }
        if (segue.identifier == "ShareLocationSegue") {
            let pointer = segue.destination as! ShareLocationViewController
            pointer.locationToShare = self.locationToShare
            pointer.fireUserID = self.fireUserID
        }
        if (segue.identifier == "SettingsSegue") {
            let pointer = segue.destination as! SettingsTableViewController
            pointer.fireUserID = self.fireUserID
            pointer.userEmail = self.userEmail
            pointer.userPassword = self.userPassword
        }
        if (segue.identifier == "FavLocMapViewSegue") {
            let pointer = segue.destination as! FavLocMapViewController
            pointer.locationID = self.locationID
        }
        if (segue.identifier == "StartJourneySegue") {
            let pointer = segue.destination as! StartJourneyMapViewController
            pointer.journeyToStart = self.journeyToStart
            pointer.fireUserID = self.fireUserID
        }
        if (segue.identifier == "liveJourneysSegue") {
            let pointer = segue.destination as! LiveJourneysTableViewController
            pointer.fireUserID = self.fireUserID
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return listOfFavorites.count
        case 1: return listOfSharedFavorites.count
        default: fatalError("Unknown section")
        }
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "My Favorites"
        } else {
            return "Shared Favorites"
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

 
}
