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
    var latitude = CLLocationCoordinate2D()
    var longitude = CLLocationCoordinate2D()
    var fireUserID = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        createSubscribedUsersArray()
        
        picker.delegate = self
        picker.dataSource = self
        
        getDestinationCoordinates()
        
    }
    
    func createSubscribedUsersArray() {
       let databaseRef = FIRDatabase.database().reference().child("SubscribedUsers").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            //print (snapshot)
            
            for item in snapshot.children {
                
                var user = String()
                
                if let userID = item as? FIRDataSnapshot {
                    //print (userID)
                    for item2 in userID.children {
                        if let pair = item2 as? FIRDataSnapshot {
                            if let userName = pair.key as? String {
                                //print (userName)
                                user = userName
                                self.arrayOfSubscribedUsers.append(user)
                            }
                            
                        }
                    }
                    //self.populateArray()
                }
            }
            self.picker.reloadAllComponents()
        })
        
    }
 
    /*
    func populateArray() {
        for item in userArray {
            arrayOfSubscribedUsers.append(item)
        }
        
    }
    */
    
    func getDestinationCoordinates() {
        let databaseRef = FIRDatabase.database().reference().child("Locations").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                if let locationID = item as? FIRDataSnapshot {
                    
                    for item in locationID.children {
                        if let pair = item as? FIRDataSnapshot {
                            
                            if let value = pair.value as? CLLocationCoordinate2D {
                                
                                let latCoord = pair.key
                                
                                if latCoord == "Latitude" {
                                    self.latitude = value
                                    print (self.latitude)
                                } else {
                                    self.longitude = value
                                    print (self.longitude)
                                }
                                
                            }
                        }
                    }
                }
                
                
            }
            //self.saveDestinationCoordToDB()
        })
    }
    
    /*
    func saveDestinationCoordToDB() {
        let ref = FIRDatabase.database().reference()
        let destination = ref.child("Started Journeys").child(fireUserID)
        let destinationCoordinates = ["DestinationLat" : latitude, "DestinationLong" : longitude]
        let childUpdates = ["/Started Journeys/\(destination)" : destinationCoordinates]
        ref.updateChildValues(childUpdates)
    }
    */
    
   
    @IBAction func shareJourney(_ sender: Any) {
        //print (myLocation)
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
    }
    
    
   
}
