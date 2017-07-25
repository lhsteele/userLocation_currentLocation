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
import ChameleonFramework


class SaveLocationDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var label: UILabel!
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
    var handle: AuthStateDidChangeListenerHandle?
    var fireUserID = String()
    var locationAutoKey = String()
    var favoriteLocationsArray = [String]()
    var usersCreatedLocationKey = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        locationCoordinates.text = "\(latCoordPassed);\(longCoordPassed)"
        
        self.locationNameField.delegate = self
        locationNameField.returnKeyType = UIReturnKeyType.done
        
        saveFavorite.setTitleColor(FlatTealDark(), for: UIControlState.normal)
        self.navigationController?.navigationBar.tintColor = FlatWhite()
        label.textColor = FlatTealDark()
        
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
        let databaseRef = Database.database().reference()
        
        locationAutoKey = databaseRef.child("Locations").childByAutoId().key
        print (locationAutoKey)
        let location = ["Latitude": newLatCoord, "Longitude": newLongCoord, "LocationName": newFavLoc, "CreatedBy": [fireUserID]] as [String : Any]
        let childUpdates = ["/Locations/\(locationAutoKey)" : location]
        databaseRef.updateChildValues(childUpdates)
       
        addLocToUser()
    }
    
    func addLocToUser() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("Users").child(userID).child("CreatedLocations")
            usersCreatedLocationKey = ref.childByAutoId().key
            print ("usersCreatedLocationKey/\(usersCreatedLocationKey)")
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

    
