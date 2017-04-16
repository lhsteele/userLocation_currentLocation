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
    //var favoriteLocationsArray = [String]()
    
    
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
        
        var databaseRef: FIRDatabaseReference!
        
        databaseRef = FIRDatabase.database().reference()
        
        key = databaseRef.child("Locations").childByAutoId().key
        let location = ["Latitude": newLatCoord, "Longitude": newLongCoord, "LocationName": newFavLoc, "Users": [fireUserID]] as [String : Any]
        let childUpdates = ["/Locations/\(key)" : location]
        databaseRef.updateChildValues(childUpdates)
        
        print (key)
    }
    
    func addLocationToUser() {
        
        var databaseRef: FIRDatabaseReference!
        
        databaseRef = FIRDatabase.database().reference()
        
        let userKey = databaseRef.child("Users").child("FavoriteLocations").childByAutoId().key
        //let favorite = [userKey : key]
        let childUpdates = ["/Users/\(userKey)" : key]
        databaseRef.updateChildValues(childUpdates)
    }
    
    /*
    func  addLocationToUser() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        let values = ["Favorite Locations" : [key]]
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            ref.child("Users").child(userID).updateChildValues(values) { (err, ref) in
                
                if err != nil {
                    return
                }
            }
        }
        
    }
    */
   
    
    @IBAction func saveFavorite(_ sender: Any) {
        addToFirebase()
        addLocationToUser()
        
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

    
