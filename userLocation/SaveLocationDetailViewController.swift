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
    var latIntPassed = Int()
    var longIntPassed = Int()
    var newLatCoord = Int()
    var newLongCoord = Int()
    var username = ""
    var dbLat = Int()
    var dbLong = Int()
    var dbLocation = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationCoordinates.text = "\(latIntPassed);\(longIntPassed)"
        
        self.locationNameField.delegate = self
                
    }
    
    
    func saveNewFavLoc () {
        if let text = locationNameField.text {
            locationNameString = "\(text)"
        }
        newLatCoord = latIntPassed
        newLongCoord = longIntPassed
        newFavLoc = locationNameString
        
        print (newLatCoord)
        print (newLongCoord)
        print (newFavLoc)
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
    
    
    @IBAction func saveFavorite(_ sender: Any) {
        /*
        let defaults = UserDefaults.standard
        //defaults.removeObject(forKey: "NewFavoriteLocation")
        
        if let existingFavLoc = defaults.string(forKey: "NewFavoriteLocation") {
            defaults.set(existingFavLoc + "+" + newFavLoc, forKey: "NewFavoriteLocation")
        } else {
            defaults.set(newFavLoc, forKey: "NewFavoriteLocation")
        }
        */
        
        
        func addToFirebase() {
        
            dbLat = newLatCoord
            dbLong = newLongCoord
            dbLocation = newFavLoc
            
            print ("\("DB")\(dbLat)")
            print ("\("DB")\(dbLong)")
            print ("\("DB")\(dbLocation)")
            
            username = "Lisa"
            
            
            
            //let databaseFavLoc: [String : String] = ["Latitude": dbLat, "Longitude" : dbLong, "Location" : dbLocation]
            
            var databaseRef: FIRDatabaseReference!
            
            databaseRef = FIRDatabase.database().reference()
            
            databaseRef.child("Lisa").childByAutoId().setValue(["Latitude" : dbLat])
            //databaseRef.child(username).childByAutoId().setValue(["Longitude" : dbLong])
            //databaseRef.child(username).childByAutoId().setValue(["Location" : newFavLoc])
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

    
