//
//  saveLocationDetailViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 1/17/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase

class SaveLocationDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var locationNameField: UITextField!
    @IBOutlet var locationCoordinates: UILabel!
    @IBOutlet var saveFavorite: UIButton!
    
    var locationName: SavedFavorites?
    var coordinatesPassed = ""
    var locationNameString = String()
    var newFavLoc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationCoordinates.text = coordinatesPassed
        
        self.locationNameField.delegate = self
        
    }
    
    
    func saveNewFavLoc () {
        if let text = locationNameField.text {
            locationNameString = "\(text)"
        }
        let newFavCoord = coordinatesPassed
        newFavLoc = newFavCoord + (locationNameString)
    }
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.locationNameField {
            self.locationName?.location = textField.text
        }
    }

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationNameField.resignFirstResponder()
        saveNewFavLoc()
        return true
    }
    
    
    @IBAction func saveFavorite(_ sender: Any) {
        let defaults = UserDefaults.standard
        //defaults.removeObject(forKey: "NewFavoriteLocation")
        
        if let existingFavLoc = defaults.string(forKey: "NewFavoriteLocation") {
            defaults.set(existingFavLoc + "+" + newFavLoc, forKey: "NewFavoriteLocation")
        } else {
            defaults.set(newFavLoc, forKey: "NewFavoriteLocation")
        }
        
        
        func addToFirebase(tuple: (lat: String, long:String, location: String)) {
        
            let dbLat = tuple.lat
            let dbLong = tuple.long
            let dbLocation = tuple.location
            
            let newDBFavourite = SavedFavorites(latCoord: dbLat, longCoord: dbLong, location: dbLocation)
            
            let databaseFavLoc : [String: String] = ["Latitude" : dbLat, "Longitude" : dbLong, "Location Name" : dbLocation]
            
            var databaseRef: FIRDatabaseReference!
            
            databaseRef = FIRDatabase.database().reference()
            
            databaseRef.child("UserFavorites").childByAutoId().setValue(databaseFavLoc)
        }
            
            //Here, we need to send this information to iCloud. Send key in similar data structure.
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

    
