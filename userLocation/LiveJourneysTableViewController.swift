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
import ChameleonFramework

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
    //var usersSharingJourneys: [String] = []
    var userSharingJourney = String()
    var journeyIsLive = false
    var sharedUserID = String()
    var journeyToEnd = String()
    var handle: AuthStateDidChangeListenerHandle?
    var journeyUserID = String()
    var journeyUserName = String()
    var sharedWithUserID = String()
    var sharedWithUsername = String()
    var sharingUserID = String()
    var sharingUsername = String()
    var boolIsTrue: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserLiveJourney()
        loadSharedWithLiveJourneyData()
        tableView.reloadData()
       //usernamesSharingJourneys()
        
        self.navigationController?.navigationBar.tintColor = FlatWhite()
    }
    
    func loadUserLiveJourney() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        if let userID = Auth.auth().currentUser?.uid {
            let locationKey = ref.child("StartedJourneys").child(userID)
            
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let liveJourneys = snapshot.children
                
                for item in liveJourneys {
                    
                    if let pair = item as? DataSnapshot {
                        print (pair)
                            if let boolean = pair.value as? Bool {
                                let boolKey = pair.key
                                if boolKey == "JourneyEnded" {
                                    print ("journeyEnded reached")
                                    if boolean != true {
                                        self.loadUserLiveDataForTable()
                                    } else {
                                        return
                                    }
                                }
                            }
                    }
                }
                self.loadLiveJourneyData()
            })
        }
    }
    
    func loadUserLiveDataForTable() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        if let userID = Auth.auth().currentUser?.uid {
            let locationKey = ref.child("StartedJourneys").child(userID)
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                let liveJourneys = snapshot.children
                for item in liveJourneys {
                    if let pair = item as? DataSnapshot {
                        if let value = pair.value as? String {
                            let key = pair.key
                            
                            if key == "SharedWithUser" {
                                self.sharedWithUsername = value
                            } else if key == "DestinationName" {
                                self.locationID = value
                            }
                            self.userCurrentJourneyLocation = "\(self.locationID): shared with \(self.sharedWithUsername)"
                            print ("userCurrentJourneyLocation \(self.userCurrentJourneyLocation)")
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
    
    
    func loadLiveJourneyData() {
        let databaseRef = Database.database().reference().child("StartedJourneys").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: fireUserID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                var cLat = Double()
                var cLong = Double()
                var dLat = Double()
                var dLong = Double()
                
                if let sharedJourneyCoordinates = item as? DataSnapshot {
                    for item in sharedJourneyCoordinates.children {
                        if let pair = item as? DataSnapshot {
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
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("SharedWithLiveJourneys").queryOrderedByKey()
            _ = databaseRef.queryEqual(toValue: userID).observe(.value, with: { (snapshot) in
                print (snapshot)
                for item in snapshot.children {
                    
                    if let journeyLoc = item as? DataSnapshot {
                        
                        for item in journeyLoc.children {
                            if let pair = item as? DataSnapshot {
                                if let boolean = pair.value as? Bool {
                                    let boolKey = pair.key
                                    if boolKey == "JourneyEnded" {
                                        print ("journeyEnded reached")
                                        if boolean != true {
                                            self.loadSharedWithLiveDataForTable()
                                        } else {
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            })
        }
    }
    
    func loadSharedWithLiveDataForTable() {
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("SharedWithLiveJourneys").queryOrderedByKey()
            _ = databaseRef.queryEqual(toValue: userID).observe(.value, with: { (snapshot) in
                for item in snapshot.children {
                    if let journeyLoc = item as? DataSnapshot {
                        for item in journeyLoc.children {
                            if let pair = item as? DataSnapshot {
                                if let user = pair.value as? String {
                                    let name = pair.key
                                    if name == "DestinationName" {
                                        self.destinationName = user
                                        print (self.destinationName)
                                        
                                    } else if name == "UserMakingJourney" {
                                        self.sharingUsername = user
                                        print (self.sharingUsername)
                                        self.sharedWithUserData = "\(self.sharingUsername): going to \(self.destinationName)"
                                    }
                                }
                            }
                        }
                        self.userSharingJourney = self.sharedWithUserData
                        print ("userSharingJourney\(self.userSharingJourney)")
                        self.getSharedCoordinates()
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
  
    func getSharedCoordinates() {
        let databaseRef = Database.database().reference().child("SharedWithLiveJourneys").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: fireUserID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                var cLat = Double()
                var cLong = Double()
                var dLat = Double()
                var dLong = Double()
                
                if let sharedJourneyCoordinates = item as? DataSnapshot {
                    for item in sharedJourneyCoordinates.children {
                        if let pair = item as? DataSnapshot {
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
        case 1: return 1
        default: fatalError("Unknown section")
        }
    }
 
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let userData = self.userCurrentJourneyLocation
        let sharedData = self.userSharingJourney
        if indexPath.section == 0 {
            cell.textLabel?.text = userData
            cell.textLabel?.textColor = FlatTeal()
        } else {
            cell.textLabel?.text = sharedData
            cell.textLabel?.textColor = FlatTeal()
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        _ = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if indexPath.section != 0 {
            performSegue(withIdentifier: "LiveJourneyMapViewSegue", sender: self)
        }
    }
 
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        let label = UILabel()
        containerView.addSubview(label)
        
        if section == 0 {
            label.text = "My Current Journey"
            label.textColor = FlatTealDark()
        } else {
            label.text = "Live Journeys Shared With Me"
            label.textColor = FlatTealDark()
        }
        label.sizeToFit()
        let labelHeight = label.frame.size.height
        let newFrame = CGRect(x: 10, y: (45 - labelHeight)/2, width: label.frame.size.width, height: label.frame.size.height)
        label.frame = newFrame
        return containerView
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
    
    func updateUserLiveJourneyBoolean() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
            let destination = ref.child("StartedJourneys").child(userID)
            let update = ["JourneyEnded" : true]
            destination.updateChildValues(update)
        }
    }
    
    func updateSharedWithLiveJourneysBoolean(sharedUserID: String) {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        let destination = ref.child("SharedWithLiveJourneys").child(self.sharedUserID)
        let update = ["JourneyEnded" : true]
        destination.updateChildValues(update)
        self.updateUserLiveJourneyBoolean()
        //self.deleteUserLiveJourney(location: self.journeyToEnd)
    }
    
    /*
    func deleteSharedWithLiveJourneys() {
        let databaseRef = FIRDatabase.database().reference().child("SharedWithLiveJourneys").child(sharedUserID)
        databaseRef.removeValue { (error, reference) in
            self.deleteUserLiveJourney(location: self.journeyToEnd)
        }
        self.tableView.reloadData()
    }
     
    func deleteUserLiveJourney(location : String) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("StartedJourneys").child(userID)
        ref.removeValue()
        }
        self.tableView.reloadData()
     }
    */
    
    func findSharedUsersForLocation() {
        let databaseRef = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("StartedJourneys")
        if let userID = Auth.auth().currentUser?.uid {
            print (userID)
            databaseRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                print (snapshot)
                let entries = snapshot.children
                var sharedUser = ""
                for item in entries {
                    if let pair = item as? DataSnapshot {
                        print (pair)
                        if let key = pair.key as? String {
                            if key == "SharedWithUserID" {
                                if let value = pair.value as? String {
                                    sharedUser = value
                                    print (sharedUser)
                                    self.sharedUserID = sharedUser
                                    self.updateSharedWithLiveJourneysBoolean(sharedUserID: self.sharedUserID)
                                }
                            }
                        }
                    }
                }
            })
        }
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
