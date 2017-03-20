 //
//  favoriteLocationsTableViewController.swift
//  userLocation
//
//  Created by Lisa H Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseDatabase

let favoriteLocationKey = "NewFavoriteLocation"

class FavoriteLocationsTableViewController: UITableViewController {

    //var listOfFavorites: [SavedFavorites] = []
    var listOfFavorites: [String] = []
    var components = ""
    var updatedListOfFavorites = ""
    var username = ""
    var retrievedLatitude = Int()
    var retrievedLongitude = Int()
    var retrievedLocation = ""
    var databaseHandle: FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
        
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        //This code works, however it only extracts the "LocationName" for the first "Location" child. Now I need to write a for loop (?) in order to print out all the "LocationName" keys for all the "Location" children.
        /*
         FIRApp.configure()
         
         let databaseRef = FIRDatabase.database().reference().child("Users").child("Username").child("Favorites").child("Location")
         
         username = "Lisa"
         
         //use ref property and safely unwrap here with if let
         let databaseHandle = databaseRef.observe(.value, with: { (snapshot) in
         if let item = snapshot.childSnapshot(forPath: "LocationName").value as? String {
         print ("===")
         print (item)
         }
         })
         */
         //tableView.reloadData()
        
        let moveButton = UIBarButtonItem(title: "Re-order", style: .plain, target: self, action: #selector(FavoriteLocationsTableViewController.toggleEdit))
        navigationItem.leftBarButtonItem = moveButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FavoriteLocationsTableViewController.addNewFavorite))
        navigationItem.rightBarButtonItem = addButton
    }
 
    /*
    func addFavorite(tuple: (lat: String, long:String, location: String)) {
        
        let newLatCoord = tuple.lat
        let newLongCoord = tuple.long
        let newLocation = tuple.location
        
        let newFavourite = SavedFavorites(latCoord: newLatCoord, longCoord: newLongCoord, location: newLocation)
        
     
        let dbLat = newLatCoord
        let dbLong = newLongCoord
        let dbLocation = newLocation
        
        let databaseFavLoc : [String: String] = ["Latitude" : dbLat, "Longitude" : dbLong, "Location Name" : dbLocation]
        
        var databaseRef: FIRDatabaseReference!
        
        databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("UserFavorites").childByAutoId().setValue(databaseFavLoc)
     
  
        self.listOfFavorites.append(newFavourite)
      
        let newIndexPath = IndexPath(row: self.listOfFavorites.count - 1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        
    }
    */
  
    
    /*
    func resaveListOfFavorites() {
        //in this function, I need to convert the listOfFavorites back to a single string.
        //assign this to the variable updatedListOfFavorites, and this will be saved to userDefaults.
        
        //print ("ListOfFavorites \(listOfFavorites)")
        
        var i = 0
        
        var updatedListOfFavorites = ""
        
        for favorite in listOfFavorites {
            
            //put all three constants in an if to safely unwrap. need to define updatedSingleLocation before the if as an empty string. Then reassign in the if.
            
            var updatedSingleLocation = ""
            
            if let updatedLatCoord = favorite.latCoord {
                if let updatedLongCoord = favorite.longCoord {
                    if let updatedLocation = favorite.location {
                        updatedSingleLocation = "\(updatedLatCoord);\(updatedLongCoord);\(updatedLocation)"
                    }
                }
            }
            
            //print ("UpdatedSingleLocation \(updatedSingleLocation)")
            
            //do this if in two stages: unwrap listOfFavorites.last first, then compare the result of unwrapping with updatedSingleLocation.
            
            if i != listOfFavorites.count - 1 {
                updatedSingleLocation.append("+")
            }
            
            updatedListOfFavorites.append(updatedSingleLocation)
            
            i += 1
        }
        
        //let defaults = UserDefaults.standard
        //defaults.set(updatedListOfFavorites, forKey: favoriteLocationKey)
        
        
    }
    */
  
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        /*
        let favorite = self.listOfFavorites[indexPath.row]
    
        if let locationName = favorite.location {
            
            cell.textLabel?.text = locationName
        }
        */
        
        cell.textLabel?.text = listOfFavorites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.listOfFavorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        tableView.reloadData()
    }
    
    

    
    func addNewFavorite(_ sender: Any?) {
        performSegue(withIdentifier: "AddNewFavoriteSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddNewFavoriteSegue") {
            _ = segue.destination as! ViewController
        }
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
     
    }
    */
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfFavorites.count
    }
    
    func toggleEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let favoriteMoving = listOfFavorites.remove(at: fromIndexPath.row)
        listOfFavorites.insert(favoriteMoving, at: to.row)
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }
    
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
