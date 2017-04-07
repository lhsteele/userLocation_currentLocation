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
    var passedFireUserID = String()
    var finalFireID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationCoordinates.text = "\(latCoordPassed);\(longCoordPassed)"
        
        self.locationNameField.delegate = self
        locationNameField.returnKeyType = UIReturnKeyType.done
        print ("Now on Detail")
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
        
        databaseRef = FIRDatabase.database().reference()
        
        let key = databaseRef.child("Locations").childByAutoId().key
        let location = ["Latitude": newLatCoord, "Longitude": newLongCoord, "LocationName": newFavLoc, "Users": [passedFireUserID]] as [String : Any]
        let childUpdates = ["/Locations/\(key)" : location]
        databaseRef.updateChildValues(childUpdates)
        
        
    }
   
    
    @IBAction func saveFavorite(_ sender: Any) {
        addToFirebase()
        
        //performSegue(withIdentifier: "NewFavLocationSegue", sender: self)
       
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NewFavLocationSegue") {
            let pointer = segue.destination as! FavoriteLocationsTableViewController
            
            pointer.latCoordPassed = self.latCoordPassed
            pointer.longCoordPassed = self.longCoordPassed
            pointer.fireUserID = self.fireUserID
        }
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        }
        
        let passedUserID2:ViewController = self.tabBarController?.viewControllers![0] as! ViewController
        let finalFireID = passedUserID2.passedFireUserID
        
        print (passedFireUserID)
        
        print ("Final UID passed")
        print (finalFireID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }

}

    
