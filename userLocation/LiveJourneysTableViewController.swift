//
//  LiveJourneysTableViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 6/19/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Firebase

class LiveJourneysTableViewController: UITableViewController {
    
    var locationID = ""
    var currentLat = Double()
    var currentLong = Double()
    var destinationLat = Double()
    var destinationLong = Double()
    var destinationName = String()
    var sharedWithUserData = String()
    var fireUserID = String()
    var userCurrentJourney: JourneyLocation?
    var userCurrentJourneyLocation = ""
    var sharedWithLiveJourney: [JourneyLocation] = []
    var usersSharingJourneys: [String] = []
    var journeyIsLive = false
    var sharedUserID = String()
    var journeyToEnd = String()
    var handle: FIRAuthStateDidChangeListenerHandle?
    var journeyUserID = String()
    var journeyUserName = String()
    var sharedWithUserID = String()
    var sharedWithUsername = String()
    var sharingUserID = String()
    var sharingUsername = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserLiveJourney()
        loadSharedWithLiveJourneyData()
       //usernamesSharingJourneys()
    }
    
    func loadUserLiveJourney() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let locationKey = ref.child("StartedJourneys").child(userID)
            
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let liveJourneys = snapshot.children
                
                for item in liveJourneys {
                    
                    if let pair = item as? FIRDataSnapshot {
                        if let value = pair.value as? String {
                            let locID = pair.key
                            
                            if locID == "DestinationName" {
                                self.locationID = value
                                self.userCurrentJourneyLocation = self.locationID
                            }
                        }
                    }
                    print (self.userCurrentJourneyLocation)
                }
                self.loadLiveJourneyData()
            })
        }
    }
 
    
    func loadLiveJourneyData() {
        let databaseRef = FIRDatabase.database().reference().child("StartedJourneys").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: fireUserID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                var cLat = Double()
                var cLong = Double()
                var dLat = Double()
                var dLong = Double()
                
                if let sharedJourneyCoordinates = item as? FIRDataSnapshot {
                    for item in sharedJourneyCoordinates.children {
                        if let pair = item as? FIRDataSnapshot {
                            if let coordinates = pair.value as? Double {
                                
                                let name = pair.key
                                
                                if name == "CurrentLat" {
                                    cLat = coordinates
                                } else if name == "CurrentLong" {
                                    cLong = coordinates
                                } else if name == "DestinationLat" {
                                    dLat = coordinates
                                } else {
                                    dLong = coordinates
                                }
                                let newJourney = JourneyLocation(userID: self.fireUserID, currentLat: cLat, currentLong: cLong, destinationLat: dLat, destinationLong: dLong)
                                self.userCurrentJourney = newJourney
                            }
                            
                        }
                        
                    }
                }
                self.tableView.reloadData()
            }
        })
    }

    func loadSharedWithLiveJourneyData() {
        let databaseRef = FIRDatabase.database().reference().child("SharedWithLiveJourneys").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: fireUserID).observe(.value, with: { (snapshot) in
            print (snapshot)
            for item in snapshot.children {
                
                if let journeyLoc = item as? FIRDataSnapshot {
                    
                    for item in journeyLoc.children {
                        if let pair = item as? FIRDataSnapshot {
                            
                            if let user = pair.value as? String {
                                
                                let name = pair.key
                                
                                if name == "Destination" {
                                    self.destinationName = user
                                    if name == "UserMakingJourney" {
                                        self.sharingUserID = user
                                        self.usernamesSharingJourneys(sharingUserID: self.sharingUserID)
                                        self.sharedWithUserData = "\(self.sharingUsername) \(self.destinationName)"
                                        print (self.sharedWithUserData)
                                        self.getSharedCoordinates()
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            //self.tableView.reloadData()
        })
    }
    
    func usernamesSharingJourneys(sharingUserID: String) {
        let databaseRef = FIRDatabase.database().reference().child("Usernames").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: sharingUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                for item in snapshot.children {
                    
                    if let pair = item as? FIRDataSnapshot {
                        if let id = pair.value as? String {
                            let name = pair.key
                           
                            if name == self.sharingUserID {
                                self.sharingUsername = id
                                print ("sharingUsername \(self.sharingUsername)")
                            }
                            //get destination name
                            //create constant and append the two together
                            //then append to list.
                            //this will also eliminate the need for the alert.
                            
                        }
                    }
                }
            self.tableView.reloadData()
        })
    }
    
    func getSharedCoordinates() {
        let databaseRef = FIRDatabase.database().reference().child("SharedWithLiveJourneys").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: fireUserID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                var cLat = Double()
                var cLong = Double()
                var dLat = Double()
                var dLong = Double()
                
                if let sharedJourneyCoordinates = item as? FIRDataSnapshot {
                    for item in sharedJourneyCoordinates.children {
                        if let pair = item as? FIRDataSnapshot {
                            if let coordinates = pair.value as? Double {
                                
                                let name = pair.key
                                
                                if name == "CurrentLat" {
                                    cLat = coordinates
                                } else if name == "CurrentLong" {
                                    cLong = coordinates
                                } else if name == "DestinationLat" {
                                    dLat = coordinates
                                } else {
                                    dLong = coordinates
                                }
                                
                                 let newJourney = JourneyLocation(userID: self.fireUserID, currentLat: cLat, currentLong: cLong, destinationLat: dLat, destinationLong: dLong)
                                 self.sharedWithLiveJourney.append(newJourney)
                            }

                        }
                        
                    }
                }
                print (self.sharedWithLiveJourney)
                
            }
        })
    }
    
    func getUserMakingJourneyID() {
        let databaseRef = FIRDatabase.database().reference().child("SharedWithLiveJourneys").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: fireUserID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                if let children = item as? FIRDataSnapshot {
                    for item in children.children {
                        if let pair = item as? FIRDataSnapshot {
                            if let id = pair.value as? String {
                                let name = pair.key
                                
                                if name == "UserMakingJourney" {
                                    self.journeyUserID = id
                                    print ("userID \(self.journeyUserID)")
                                    self.getUserMakingJourneyName(journeyUserID : self.journeyUserID)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func getUserMakingJourneyName(journeyUserID: String) {
        print ("journeyUserID2 \(journeyUserID)")
        let databaseRef = FIRDatabase.database().reference().child("Usernames").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyUserID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                print ("item \(item)")
                
                if let pair = item as? FIRDataSnapshot {
                    
                    if let id = pair.value as? String {
                        let name = pair.key
                        
                        if name == self.journeyUserID {
                            self.journeyUserName = id
                            print ("userName \(self.journeyUserName)")
                        }
                    }
                }
            }
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 2
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return usersSharingJourneys.count
        default: fatalError("Unknown section")
        }
    }
 
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.userCurrentJourneyLocation
        } else {
            cell.textLabel?.text = self.usersSharingJourneys[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        _ = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if indexPath.section == 0 {
            journeySharedWithUser()
        } else {
            performSegue(withIdentifier: "LiveJourneyMapViewSegue", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "My Current Journey"
        } else {
            return "Live Journeys Shared With Me"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let endJourney = UITableViewRowAction(style: .normal, title: "End Journey") { (action, indexPath) in
            if indexPath.section == 0 {
                _ = self.userCurrentJourneyLocation
        
                self.findSharedUsersForLocation()
                
                self.displaySuccessAlertMessage(messageToDisplay: "Journey has been succesfully ended.")
                self.tableView.reloadData()
                
            }
        }
        return [endJourney]
    }
    
    func deleteUserLiveJourney(location : String) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("StartedJourneys").child(userID)
            ref.removeValue()
        }
        
    }
    
    func deleteSharedWithLiveJourneys() {
        let databaseRef = FIRDatabase.database().reference().child("SharedWithLiveJourneys").child(sharedUserID)
        databaseRef.removeValue { (error, reference) in
            self.deleteUserLiveJourney(location: self.journeyToEnd)
        }
    }
    
    
    func findSharedUsersForLocation() {
        let databaseRef = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("StartedJourneys")
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            print (userID)
            databaseRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                print (snapshot)
                let entries = snapshot.children
                var sharedUser = ""
                for item in entries {
                    if let pair = item as? FIRDataSnapshot {
                        print (pair)
                        if let key = pair.key as? String {
                            if key == "SharedWithUser" {
                                if let value = pair.value as? String {
                                    sharedUser = value
                                    print (sharedUser)
                                    self.sharedUserID = sharedUser
                                    self.deleteSharedWithLiveJourneys()
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    func journeySharedWithUser() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let locationKey = ref.child("StartedJourneys").child(userID)
            
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let liveJourneys = snapshot.children
                
                for item in liveJourneys {
                    
                    if let pair = item as? FIRDataSnapshot {
                        if let value = pair.value as? String {
                            let userID = pair.key
                            
                            if userID == "SharedWithUser" {
                                self.sharedWithUserID = value
                            }
                        }
                    }
                }
                self.journeySharedWithUsername(journeyUserID: self.sharedWithUserID)
            })
        }
    }
    
    func journeySharedWithUsername(journeyUserID: String) {
        let databaseRef = FIRDatabase.database().reference().child("Usernames").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: sharedWithUserID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                if let pair = item as? FIRDataSnapshot {
                    
                    if let id = pair.value as? String {
                        let name = pair.key
                        
                        if name == self.sharedWithUserID {
                            self.sharedWithUsername = id
                            self.displaySharedWithUserMessage(messageToDisplay: "This journey has been shared with \(self.sharedWithUsername)")
                        }
                    }
                }
            }
            
        })
    }
    
    func displaySuccessAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Sucess", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            //performSegue
            self.performSegue(withIdentifier: "JourneyEndedBackToFavorites", sender: self)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displaySharedWithUserMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    func appDidEnterBackground(_application: UIApplication) {
        try! FIRAuth.auth()!.signOut()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
