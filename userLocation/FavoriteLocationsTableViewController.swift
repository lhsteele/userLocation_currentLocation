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
    var sharedFavToDelete = String()
    var locationToShare = String()
    var locationNameString = String()
    var journeyToStart = String()
    var sharedLocKey = String()
    var sharedEmailsUserID = String()
    var usersCreatedLocationKey = String()
    
    
    
    
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
        
    }
    
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
        let favorite = self.listOfFavorites[indexPath.row]
        cell.textLabel?.text = favorite.location
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
            self.locationToShare = self.listOfCreatedLocations[indexPath.row] as String
            self.performSegue(withIdentifier: "ShareLocationSegue", sender: Any.self)
        }
        
        share.backgroundColor = UIColor.darkGray
        
        let startJourney = UITableViewRowAction(style: .normal, title: "Start Journey") { (action, indexPath) in
            self.journeyToStart = self.listOfCreatedLocations[indexPath.row] as String
            self.performSegue(withIdentifier: "StartJourneySegue", sender: Any.self)
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
                let userFavToDelete = self.listOfCreatedLocations[indexPath.row] as String
                self.listOfFavorites.remove(at: indexPath.row)
                self.listOfCreatedLocations.remove(at: indexPath.row)
                self.tableView.reloadData()
            
                self.startDeletion(location: userFavToDelete)
            
                //tableView.deleteRows(at: [indexPath], with: .fade)
            }
        let deleteRow = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [share, startJourney, delete]
    }
    
    //putting all deletion methods within one, with each nested in the completion handler of the previous as all are asynchronious calls.
    //Each function has an argument passed in. This way we are not depending on a global variable that may or may not have a value when we need it.
    //We know that the value exists and is being passed in to the fuction.
    //The value being passed in and the value being received are called two different things because the names are just a container for the value.
    func startDeletion(location: String) {
        deleteFromLocationsDB(secondLocation: location)
    }
    
    func deleteFromLocationsDB(secondLocation: String) {
        let locDeletionRef = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("Locations").child(secondLocation)
        locDeletionRef.removeValue { (error, reference) in
            //check error is nil before running the next. if nil, print to console.
            self.deleteFromSubscribedUsers(thirdLocation: secondLocation)
            if error != nil {
                self.deleteFromSubscribedUsers(thirdLocation: secondLocation)
            } else {
                print ("error\(reference)")
            }
        }
    }
    
    func deleteFromSubscribedUsers(thirdLocation: String) {
        let subscribedUsersDeletionRef = FIRDatabase.database().reference().child("SubscribedUsers")
        
        let locToDeleteRef = subscribedUsersDeletionRef.child(thirdLocation)
        locToDeleteRef.removeValue { (error, reference) in
            self.deleteFromUsersCreatedLocations(fourthLocation: thirdLocation)
            if error != nil {
                self.deleteFromUsersCreatedLocations(fourthLocation: thirdLocation)
            } else {
                print ("error\(reference)")
            }
        }
    }
    
    
    func deleteFromUsersCreatedLocations(fourthLocation: String) {
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("Users").child(userID).child("CreatedLocations")
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let entries = snapshot.children
                var valueToDelete = ""
                for item in entries {
                    if let pair = item as? FIRDataSnapshot {
                        if let value = pair.value as? String {
                            print (value)
                            if value == fourthLocation {
                                valueToDelete = value
                                print ("valToDelete\(valueToDelete)")
                                ref.child(pair.key).removeValue { (error, reference) in
                                    self.deleteKeyFromLocationsSharedWithUser(fifthLocation: fourthLocation)
                                    if error != nil {
                                        self.deleteKeyFromLocationsSharedWithUser(fifthLocation: fourthLocation)
                                    } else {
                                        print ("error\(reference)")
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    
    func deleteKeyFromLocationsSharedWithUser(fifthLocation: String) {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("LocationsSharedWithUser").child(sharedEmailsUserID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let entries = snapshot.children
            var valueToDelete = ""
            for item in entries {
                if let pair = item as? FIRDataSnapshot {
                    
                    if let value = pair.value as? String {
                        if value == fifthLocation {
                            valueToDelete = value
                            ref.child(pair.key).removeValue()
                        }
                    }
                }
            }
        })
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        _ = tableView.cellForRow(at: indexPath)! as UITableViewCell
        performSegue(withIdentifier: "FavLocMapViewSegue", sender: self)
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFavorites.count
    }
    
    func toggleEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let favoriteMoving = listOfFavorites.remove(at: fromIndexPath.row)
        listOfFavorites.insert(favoriteMoving, at: to.row)
    }
    */

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
