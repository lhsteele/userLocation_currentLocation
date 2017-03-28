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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationCoordinates.text = "\(latCoordPassed);\(longCoordPassed)"
        
        self.locationNameField.delegate = self
                
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
        
       //username = "Lisa"
        
        var databaseRef: FIRDatabaseReference!
        
        databaseRef = FIRDatabase.database().reference().child("Users").child("Username")
        
        let key = databaseRef.child("Favorites").childByAutoId().key
        let location = ["Latitude": newLatCoord, "Longitude": newLongCoord, "LocationName": newFavLoc] as [String : Any]
        let childUpdates = ["/Favorites/\(key)" : location]
        databaseRef.updateChildValues(childUpdates)
        
        
    }
   
    
    @IBAction func saveFavorite(_ sender: Any) {
        addToFirebase()
        
        performSegue(withIdentifier: "FavoriteLocationTableSegue", sender: sender)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavoriteLocationTableSegue") {
            _ = segue.destination as! FavoriteLocationsTableViewController
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

    
