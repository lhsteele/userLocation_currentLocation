//
//  saveLocationDetailViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 1/17/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit

class SaveLocationDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var locationNameField: UITextField!
    @IBOutlet var locationCoordinates: UILabel!
    @IBOutlet var saveFavorite: UIButton!
    
    var locationNameString = String()
    var newFavLoc = ""
    var latCoordPassed = CLLocationDegrees()
    var longCoordPassed = CLLocationDegrees()
    var newLatCoord = CLLocationDegrees()
    var newLongCoord = CLLocationDegrees()
    var username = ""
    var handle: FIRAuthStateDidChangeListenerHandle?
    var fireUserID = String()
    var key = String()
    var favoriteLocationsArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        locationCoordinates.text = "\(latCoordPassed);\(longCoordPassed)"
        
        self.locationNameField.delegate = self
        locationNameField.returnKeyType = UIReturnKeyType.done
        
        print ("SaveLoc\(fireUserID)")
    
    }
    
    
    func saveNewFavLoc () {
        if let text = locationNameField.text {
            locationNameString = "\(text)"
        }
        newLatCoord = latCoordPassed
        newLongCoord = longCoordPassed
        newFavLoc = locationNameString
        
    }
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.locationNameField {
            self.locationNameString = textField.text!
        }
    }

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationNameField.resignFirstResponder()
        saveNewFavLoc()
        return true
    }
    
    func addToFirebase() {
        var databaseRef = FIRDatabase.database().reference()
        
        key = databaseRef.child("Locations").childByAutoId().key
        let location = ["Latitude": newLatCoord, "Longitude": newLongCoord, "LocationName": newFavLoc, "Users": [fireUserID]] as [String : Any]
        let childUpdates = ["/Locations/\(key)" : location]
        databaseRef.updateChildValues(childUpdates)
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userKey = databaseRef.child("Users").child(userID).child("FavoriteLocations").key
            let listOfLocations = ["Location ID" : key]
            let updates = ["/Users/\(userKey)" : listOfLocations]
            userKey.updateChildValues(updates)
        }
    }
    
    
    /*
    func createUsersLocationArray () {
        let databaseRef2 = FIRDatabase.database().reference().child("Users").child("FavoriteLocations")
        
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
            
            //print(updatedUserArray)
        })
    }
    */
   
    
    @IBAction func saveFavorite(_ sender: Any) {
        addToFirebase()
        
        performSegue(withIdentifier: "NewFavLocationSegue", sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NewFavLocationSegue") {
            let pointer = segue.destination as! FavoriteLocationsTableViewController
            
            pointer.latCoordPassed = self.latCoordPassed
            pointer.longCoordPassed = self.longCoordPassed
            pointer.fireUserID = self.fireUserID
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }

}

    
