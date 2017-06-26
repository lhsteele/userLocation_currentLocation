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
    var journeyIsLive = false

    override func viewDidLoad() {
        super.viewDidLoad()

        createSubscribedUsersArray()
        
        picker.delegate = self
        picker.dataSource = self
        
        print (journeyToStart)
        
    }
    
    func createSubscribedUsersArray() {
       let databaseRef = FIRDatabase.database().reference().child("SubscribedUsers").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                var user = String()
                
                if let username = item as? FIRDataSnapshot {
                    
                    for item2 in username.children {
                        if let pair = item2 as? FIRDataSnapshot {
                            if let userName = pair.key as? String {
                                
                                user = userName
                                self.arrayOfSubscribedUsers.append(user)
                            }
                            
                        }
                    }
                    self.arrayOfSubscribedUsers.insert("Select User", at: 0)
                }
            }
            self.picker.reloadAllComponents()
        })
        
    }
    
    func retrieveSharedUserID() {
        let databaseRef = FIRDatabase.database().reference().child("SubscribedUsers").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                if let userid = item as? FIRDataSnapshot {
                    
                    for item2 in userid.children {
                        if let pair = item2 as? FIRDataSnapshot {
                            if let userID = pair.value as? String {
                                var usersName = pair.key
                                
                                if usersName == self.sharedUserName {
                                    self.sharedUserID = userID
                                    self.getDestinationCoordinates()
                                    
                                    return
                                }
                                print ("retrieve run")
                            }
                        }
                    }
                }
            }
        })
    }
    
    func getDestinationCoordinates() {
        let databaseRef = FIRDatabase.database().reference().child("Locations").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                if let destination = item as? FIRDataSnapshot {
                    
                    for item in destination.children {
                        if let pair = item as? FIRDataSnapshot {
                        
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
                                            self.saveDestinationCoordToDB()
                                            print ("getDestCoords run")
                                        }
                                    }
                            }
                        }
                    }
                
                }
        })
    }
    
    func saveDestinationCoordToDB() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        let destination = ref.child("StartedJourneys").child(fireUserID).key
        journeyIsLive = true
        let destinationCoordinates = ["StartedJourneys/\(destination)" : ["DestinationLat" : latitude, "DestinationLong" : longitude, "CurrentLat" : localValue.latitude, "CurrentLong" : localValue.longitude, "SharedWithUser" : sharedUserID, "DestinationName" : locationName, "JourneyIsLive" : journeyIsLive]] as [String : Any]
        ref.updateChildValues(destinationCoordinates) { (Error, FIRDatabaseReference) in
            print ("saveToDB run")
            self.saveLiveJourneyToSharedWithUser()
        }
    }
    
    func saveLiveJourneyToSharedWithUser() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        let destination = ref.child("SharedWithLiveJourneys").child(sharedUserID).key
        journeyIsLive = true
        let destinationCoordinates = ["DestinationLat" : latitude, "DestinationLong" : longitude, "CurrentLat" : localValue.latitude, "CurrentLong" : localValue.longitude, "UserMakingJourney" : fireUserID, "DestinationName" : locationName, "JourneyIsLive" : journeyIsLive] as [String : Any]
        let childUpdates = ["/SharedWithLiveJourneys/\(destination)" : destinationCoordinates]
        ref.updateChildValues(childUpdates)
        print ("saveToSharedDB run")
    }
    
    @IBAction func shareJourney(_ sender: Any) {
        retrieveSharedUserID()
        performSegue(withIdentifier: "BackToFavorites", sender: shareJourneyButton)
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
   
}
