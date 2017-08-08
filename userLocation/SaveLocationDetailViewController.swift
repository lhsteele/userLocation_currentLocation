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
    
    @IBOutlet var label: UILabel!
    @IBOutlet var locationNameField: UITextField!
    @IBOutlet var saveFavorite: UIButton!
    
    var locationNameString = String()
    var newFavLoc = ""
    var latCoordPassed = CLLocationDegrees()
    var longCoordPassed = CLLocationDegrees()
    var newLatCoord = CLLocationDegrees()
    var newLongCoord = CLLocationDegrees()
    var username = ""
    var handle: AuthStateDidChangeListenerHandle?
    var fireUserID = String()
    var locationAutoKey = String()
    var favoriteLocationsArray = [String]()
    var usersCreatedLocationKey = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
               
        self.locationNameField.delegate = self
        locationNameField.returnKeyType = UIReturnKeyType.done
        
        saveFavorite.setTitleColor(UIColor(red: 0.20, green: 0.38, blue: 0.45, alpha: 1.0), for: UIControlState.normal)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        label.textColor = UIColor(red: 0.20, green: 0.38, blue: 0.45, alpha: 1.0)
        
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
        let databaseRef = Database.database().reference()
        
        locationAutoKey = databaseRef.child("Locations").childByAutoId().key
        let location = ["Latitude": newLatCoord, "Longitude": newLongCoord, "LocationName": newFavLoc, "CreatedBy": [fireUserID]] as [String : Any]
        let childUpdates = ["/Locations/\(locationAutoKey)" : location]
        databaseRef.updateChildValues(childUpdates)
       
        addLocToUser()
    }
    
    func addLocToUser() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("Users").child(userID).child("CreatedLocations")
            usersCreatedLocationKey = ref.childByAutoId().key
            let updates = [usersCreatedLocationKey : locationAutoKey]
            ref.updateChildValues(updates)
        }
        
    }
    
   
    
    @IBAction func saveFavorite(_ sender: Any) {
        addToFirebase()
        performSegue(withIdentifier: "NewFavLocationSegue", sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NewFavLocationSegue") {
            let pointer = segue.destination as! FavoriteLocationsTableViewController
            pointer.usersCreatedLocationKey = self.usersCreatedLocationKey
            pointer.latCoordPassed = self.latCoordPassed
            pointer.longCoordPassed = self.longCoordPassed
            pointer.fireUserID = self.fireUserID
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    
