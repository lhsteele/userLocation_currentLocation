//
//  saveLocationDetailViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 1/17/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class saveLocationDetailViewController: UIViewController, UITextFieldDelegate {
    
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
        locationNameString = "\(locationNameField.text)"
        
        var newFavCoord = coordinatesPassed
        newFavLoc = newFavCoord + (locationNameString)
        
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
        defaults.set(newFavLoc, forKey: "NewFavoriteLocation")
        
        performSegue(withIdentifier: "favoriteLocationTableSegue", sender: sender)
        
        print(newFavLoc)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "favoriteLocationTableSegue") {
            let pTwo = segue.destination as! favoriteLocationsTableViewController
        
            pTwo.favorite = self.newFavLoc
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

    
