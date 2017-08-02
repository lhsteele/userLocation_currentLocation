//
//  ShareJourneyPickerViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/12/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase
import MapKit
//import ChameleonFramework

class ShareJourneyPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var shareJourneyButton: UIButton!
    @IBOutlet var pickerLabel: UILabel!
    @IBOutlet var picker: UIPickerView!
    
    var journeyToStart = String()
    var arrayOfSubscribedUsers = [String]()
    var userArray = [String]()
    var finalArray = [String]()
    var localValue = CLLocationCoordinate2D()
    var fireUserID = String()
    var sharedUserName = String()
    var sharedUserID = String()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var locationName = String()
    var handle: AuthStateDidChangeListenerHandle?
    var usernameMakingJourney = String()
    var journeyEnded: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        createSubscribedUsersArray()
        
        picker.delegate = self
        picker.dataSource = self
        
        print (journeyToStart)
        print (fireUserID)
        
        /*
        view.backgroundColor = FlatTeal()
        shareJourneyButton.setTitleColor(FlatWhite(), for: UIControlState.normal)
        pickerLabel.textColor = FlatWhite()
        picker.tintColor = FlatWhite()
        self.navigationController?.navigationBar.tintColor = FlatWhite()
        */
        view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        shareJourneyButton.setTitleColor(UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0), for: UIControlState.normal)
        pickerLabel.textColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        picker.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
    }
    
    func createSubscribedUsersArray() {
       let databaseRef = Database.database().reference().child("SubscribedUsers").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                var user = String()
                
                if let username = item as? DataSnapshot {
                    
                    for item2 in username.children {
                        if let pair = item2 as? DataSnapshot {
                            let userName = pair.key
                                user = userName
                                self.arrayOfSubscribedUsers.append(user)
                        }
                    }
                    self.arrayOfSubscribedUsers.insert("Select User", at: 0)
                }
            }
            self.picker.reloadAllComponents()
        })
        
    }
    
    func retrieveSharedUserID() {
        let databaseRef = Database.database().reference().child("SubscribedUsers").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                if let userid = item as? DataSnapshot {
                    
                    for item2 in userid.children {
                        if let pair = item2 as? DataSnapshot {
                            if let userID = pair.value as? String {
                                let usersName = pair.key
                                
                                if usersName == self.sharedUserName {
                                    self.sharedUserID = userID
                                    self.checkIfUserAlreadyHasSharedJourney(userID: self.sharedUserID)
                                    //self.getDestinationCoordinates(userID : self.sharedUserID)
                                }
                                print ("retrieve run")
                            }
                        }
                    }
                }
            }
        })
    }
    
    func checkIfUserAlreadyHasSharedJourney(userID: String) {
        let ref = Database.database().reference().child("SharedWithLiveJourneys").queryOrderedByKey()
        ref.queryEqual(toValue: self.sharedUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.displayErrorAlertMessage(messageToDisplay: "Unable to share your journey with this user. Another user is already sharing their journey with them.")
            } else {
                self.getDestinationCoordinates(userID: self.sharedUserID)
            }
        })
        
    }
 
    func getDestinationCoordinates(userID : String) {
        let databaseRef = Database.database().reference().child("Locations").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                print (snapshot)
                if let destination = item as? DataSnapshot {
                    
                    for item in destination.children {
                        if let pair = item as? DataSnapshot {
                        
                            if let location = pair.value as? String {
                                
                                        self.locationName = location
                                    } else {
                                        if let value = pair.value as? CLLocationDegrees {
                                            
                                            let lat = pair.key
                                            
                                            if lat == "Latitude" {
                                                self.latitude = value
                                            } else {
                                                self.longitude = value
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    self.saveDestinationCoordToDB()
                }
        })
    }
    
    func saveDestinationCoordToDB() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
            let destination = ref.child("StartedJourneys").child(userID).key
            let destinationCoordinates = ["StartedJourneys/\(destination)" : ["DestinationLat" : latitude, "DestinationLong" : longitude, "CurrentLat" : localValue.latitude, "CurrentLong" : localValue.longitude, "SharedWithUser" : sharedUserName, "DestinationName" : locationName, "SharedWithUserID" : self.sharedUserID, "JourneyEnded" : journeyEnded]] as [String : Any]
            print ("destCoords\(destinationCoordinates)")
            ref.updateChildValues(destinationCoordinates) { (Error, FIRDatabaseReference) in
                self.retrieveUsername()
            }
        }
    }
    
    
    func retrieveUsername() {
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("Usernames").queryOrderedByKey()
            databaseRef.queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { (snapshot) in
                for item in snapshot.children {
                    if let pair = item as? DataSnapshot {
                        if let name = pair.value as? String {
                            let key = pair.key
                            
                            if key == userID {
                                self.usernameMakingJourney = name
                                print (self.usernameMakingJourney)
                                self.saveLiveJourneyToSharedWithUser(userID: self.sharedUserID)
                            }
                        }
                    }
                }
            })
        }
    }
    
    
    func saveLiveJourneyToSharedWithUser(userID: String) {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
            let destination = ref.child("SharedWithLiveJourneys").child(sharedUserID).key
            let destinationCoordinates = ["DestinationLat" : latitude, "DestinationLong" : longitude, "CurrentLat" : localValue.latitude, "CurrentLong" : localValue.longitude, "UserMakingJourney" : self.usernameMakingJourney, "DestinationName" : locationName, "UserIDMakingJourney" : userID, "JourneyEnded" : journeyEnded] as [String : Any]
            let childUpdates = ["/SharedWithLiveJourneys/\(destination)" : destinationCoordinates]
            ref.updateChildValues(childUpdates)
        }
        displaySuccessAlertMessage(messageToDisplay: "Your journey has been shared.")
    }
    
    @IBAction func shareJourney(_ sender: Any) {
        retrieveSharedUserID()
        print ("perform Segue")
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfSubscribedUsers.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfSubscribedUsers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerLabel.text = arrayOfSubscribedUsers[row]
        sharedUserName = pickerLabel.text!
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: arrayOfSubscribedUsers[row], attributes: [NSForegroundColorAttributeName : UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)])
        return attributedString
    }
    
    func displaySuccessAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Success", message: messageToDisplay, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            self.performSegue(withIdentifier: "PickerToLiveJourneysSegue", sender: self)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayErrorAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            self.performSegue(withIdentifier: "BackToFavorites", sender: self)
        }
        alertController.addAction(okAction)
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
   
}
