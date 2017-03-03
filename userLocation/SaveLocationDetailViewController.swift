//
//  saveLocationDetailViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 1/17/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

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
            
            print("LocationNameString \(locationNameString)")
        }
        
        let newFavCoord = coordinatesPassed
        newFavLoc = newFavCoord + (locationNameString)
        
        print("NewFavLoc \(newFavLoc)")
        
    }
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.locationNameField {
            self.locationName?.location = textField.text
            
        }
        
        //textField.returnKeyType = UIReturnKeyType.done
        
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
        
        
        //Here, we need to send this information to iCloud. Send key in similar data structure.
        
        
        Zephyr.sync(keys: "NewFavoriteLocation")
        
        
        
        performSegue(withIdentifier: "FavoriteLocationTableSegue", sender: sender)
       
    }
    
    //Need to call synchronization in order for data to actually be saved to icloud?
    //This is taken from the Zephyr.swift file, line 90
    /*
    public static func sync(keys: String...) {
        if keys.count > 0 {
            sync(keys: keys)
            return
        }
        
        switch sharedInstance.dataStoreWithLatestData() {
        case .local:
            printGeneralSyncStatus(finished: false, destination: .remote)
            sharedInstance.zephyrQueue.sync {
                sharedInstance.syncToCloud()
            }
            printGeneralSyncStatus(finished: true, destination: .remote)
        case .remote:
            printGeneralSyncStatus(finished: false, destination: .local)
            sharedInstance.zephyrQueue.sync {
                sharedInstance.syncFromCloud()
            }
            printGeneralSyncStatus(finished: true, destination: .local)
        }
    }
 */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavoriteLocationTableSegue") {
            let pTwo = segue.destination as! FavoriteLocationsTableViewController
        
            //pTwo.favorite = self.newFavLoc
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

    
