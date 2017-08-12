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
import FirebaseMessaging
import UserNotifications

let favoriteLocationKey = "NewFavoriteLocation"

class FavoriteLocationsTableViewController: UITableViewController, CLLocationManagerDelegate, UINavigationBarDelegate, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    
    var listOfFavorites: [SavedFavorites] = []
    var listOfCreatedLocations = [String]()
    var listOfSharedFavorites: [SavedFavorites] = []
    var listOfSharedLocations = [String]()
    var locationID = ""
    var username = ""
    var ref: DatabaseReference?
    var handle: AuthStateDidChangeListenerHandle?
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
    var sharedUserName = String()
    var sharedUserID = String()
    
    
    @IBOutlet var journeysButton: UIBarButtonItem!
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet var addLocationButton: UIButton!
   
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        settingsButton.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        journeysButton.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)

        addLocationButton.setTitleColor(UIColor(red: 0.20, green: 0.38, blue: 0.45, alpha: 1.0), for: UIControlState.normal)
        addLocationButton.layer.borderWidth = 1
        addLocationButton.layer.borderColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0).cgColor
        addLocationButton.layer.cornerRadius = 10
        
        loadFavorites()
        
    }
    
    func showPopup() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpVC") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    func loadFavorites() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        
        if let userID = Auth.auth().currentUser?.uid {
            
            let locationKey = ref.child("Users").child(userID).child("CreatedLocations")
            
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                let createdLocations = snapshot.children
                
                for item in createdLocations {
                    
                    if let pair = item as? DataSnapshot {
                        if let locID = pair.value as? String {
                            self.locationID = locID
                        }
                    }
                    
                    self.listOfCreatedLocations.append(self.locationID)
                }
                if self.listOfCreatedLocations.isEmpty {
                    print ("list is empty")
                    self.showPopup()
                }
                self.loadData()
            })
            
        }
        self.loadSharedLocations()
    }
    
    func loadSharedLocations() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        
        if let userID = Auth.auth().currentUser?.uid {
            
            let locationKey = ref.child("LocationsSharedWithUser").child(userID)
            
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let sharedLocations = snapshot.children
                
                for item in sharedLocations {
                    if let pair = item as? DataSnapshot {
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
            
            let databaseRef = Database.database().reference().child("Locations").queryOrderedByKey()
            _ = databaseRef.queryEqual(toValue: item).observe(.value, with: { (snapshot) in
                
                for item2 in snapshot.children {
                    
                    var updatedLocation = ""
                    var updatedLat = Double()
                    var updatedLong = Double()
                    
                    if let dbLocation = item2 as? DataSnapshot {
                        
                        for item2 in dbLocation.children {
                            
                            if let pair = item2 as? DataSnapshot {
                                
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
            
            let databaseRef = Database.database().reference().child("Locations").queryOrderedByKey()
            _ = databaseRef.queryEqual(toValue: item).observe(.value, with: { (snapshot) in
                
                for item2 in snapshot.children {
                    
                    var updatedLocation = ""
                    var updatedLat = Double()
                    var updatedLong = Double()
                    
                    if let dbLocation = item2 as? DataSnapshot {
                        
                        for item2 in dbLocation.children {
                            
                            if let pair = item2 as? DataSnapshot {
                                
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
        let databaseRef2 = Database.database().reference().child("Locations")
        
        _ = databaseRef2.observe(.childAdded, with: { snapshot in
            var subscribedUser = DataSnapshot()
            var updatedUserArray = [DataSnapshot]()
            
            for item in snapshot.children {
                
                if let user = item as? DataSnapshot {
                    
                    for item2 in user.children {
                        
                        if let userID = item2 as? DataSnapshot {
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
        cell.textLabel?.textColor = UIColor(red: 0.20, green: 0.38, blue: 0.45, alpha: 1.0)
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
            self.checkForExistingLiveJourney()
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
                let userFavToDelete = self.listOfCreatedLocations[indexPath.row] as String
                self.listOfFavorites.remove(at: indexPath.row)
                self.listOfCreatedLocations.remove(at: indexPath.row)
                self.tableView.reloadData()
                self.startDeletion(location: userFavToDelete)
            }
        _ = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [share, startJourney, delete]
    }
    
    func startDeletion(location: String) {
        deleteFromLocationsDB(secondLocation: location)
    }
    
    func deleteFromLocationsDB(secondLocation: String) {
        let locDeletionRef = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("Locations").child(secondLocation)
        locDeletionRef.removeValue { (error, reference) in
            if error != nil {
                print ("error\(reference)")
            } else {
                self.findSharedEmailsUserID(thirdLocation: secondLocation)
            }
        }
    }
    
    func findSharedEmailsUserID(thirdLocation: String) {
        let databaseRef = Database.database().reference().child("SubscribedUsers").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: thirdLocation).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                for item in snapshot.children {
                    
                    if let userid = item as? DataSnapshot {
                        
                        for item2 in userid.children {
                            if let pair = item2 as? DataSnapshot {
                                if let userID = pair.value as? String {
                                    self.sharedUserID = userID
                                    self.deleteKeyFromLocationsSharedWithUser(fourthLocation: thirdLocation)
                                }
                            }
                        }
                    }
                }
                
            } else {
                self.deleteFromUsersCreatedLocations(sixthLocation: thirdLocation )
            }
        })
    }
    
    func deleteKeyFromLocationsSharedWithUser(fourthLocation: String) {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("LocationsSharedWithUser").child(sharedUserID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let entries = snapshot.children
                for item in entries {
                    if let pair = item as? DataSnapshot {
                        
                        if let value = pair.value as? String {
                            if value == fourthLocation {
                                let keyToDelete = pair.key
                                 ref.child(keyToDelete).removeValue()
                            }
                        }
                    }
                    self.deleteFromSubscribedUsers(fifthLocation: fourthLocation)
                }
            } else {
                return
            }
        })
    }
    

    
    func deleteFromSubscribedUsers(fifthLocation: String) {
        let subscribedUsersDeletionRef = Database.database().reference().child("SubscribedUsers")
        
        let locToDeleteRef = subscribedUsersDeletionRef.child(fifthLocation)
        locToDeleteRef.removeValue { (error, reference) in
            if error != nil {
                print ("error\(reference)")
            } else {
                self.deleteFromUsersCreatedLocations(sixthLocation: fifthLocation)
            }
        }
    }
    
    
    func deleteFromUsersCreatedLocations(sixthLocation: String) {
        
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("Users").child(userID).child("CreatedLocations")
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let entries = snapshot.children
                var valueToDelete = ""
                for item in entries {
                    if let pair = item as? DataSnapshot {
                        if let value = pair.value as? String {
                            if value == sixthLocation {
                                valueToDelete = value
                                ref.child(pair.key).removeValue { (error, reference) in
                                    if error != nil {
                                        print ("error\(reference)")
                                    } else {
                                        //self.findSharedEmailsUserID(fifthLocation: fourthLocation)
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    
    
    func checkForExistingLiveJourney() {
        if let userID = Auth.auth().currentUser?.uid {
        let databaseRef = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("StartedJourneys").child(userID)
            _ = databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let children = snapshot.children
                    for item in children {
                        if let pair = item as? DataSnapshot {
                            print (pair)
                            if let boolean = pair.value as? Bool {
                                let boolKey = pair.key
                                if boolKey == "JourneyEnded" {
                                    if boolean != true {
                                        self.displayErrorAlertMessage(messageToDisplay: "You are currently on a journey and have already shared it with another user.")
                                    } else {
                                        self.performSegue(withIdentifier: "StartJourneySegue", sender: Any.self)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.performSegue(withIdentifier: "StartJourneySegue", sender: Any.self)
                }
                
            })
        }
    }
    
    func displayErrorAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        _ = tableView.cellForRow(at: indexPath)! as UITableViewCell
        self.locationID = self.listOfCreatedLocations[indexPath.row] as String
        performSegue(withIdentifier: "FavLocMapViewSegue", sender: self)
    }
    
    @IBAction func addNewLocation(_ sender: Any) {
        performSegue(withIdentifier: "MapViewSegue", sender: addLocationButton)
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
        self.requestNotificationAuthorisation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func appDidEnterBackground(_application: UIApplication) {
        try! Auth.auth().signOut()
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
    
    func requestNotificationAuthorisation() {
        if #available(iOS 10, *) {
            
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default()
            
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {(granted, error) in
                if (error != nil) {
                    print ("I received the following error: \(String(describing: error))")
                } else if (granted) {
                    print ("Authorization was granted!")
                    self.printFCMToken()
                } else {
                    print ("Authorization was not granted.")
                }
            }
        
            
        } else {
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default()
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func checkIfRegisteredForNotifications() {
        let isRegistered = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegistered {
            print ("userIsRegisteredForNotifications")
            self.printFCMToken()
        } 
    }
    
    func addTokenToDB(userToken : String) {
        print ("userToken\(userToken)")
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("UserTokens")
            let updates = [userID : userToken]
            ref.updateChildValues(updates)
        }
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if InstanceID.instanceID().token() != nil {
            printFCMToken()
        } else {
            print ("We dont have an FCM token yet.")
        }
        connectToFCM()
    }
    
    func printFCMToken() {
        if let token = InstanceID.instanceID().token() {
            print ("Your FCM token is \(token)")
            self.addTokenToDB(userToken : token)
        } else {
            print ("You don't get have an FCM token.")
        }
    }
    
    func connectToFCM() {
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        
        Messaging.messaging().shouldEstablishDirectChannel = false
        
        if Messaging.messaging().isDirectChannelEstablished == true {
            print ("Connected to FCM")
        } else {
            print ("Unable to connect with FCM.")
        }
    }
    
    

}
