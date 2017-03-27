 //
//  favoriteLocationsTableViewController.swift
//  userLocation
//
//  Created by Lisa H Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

let favoriteLocationKey = "NewFavoriteLocation"

class FavoriteLocationsTableViewController: UITableViewController {
    
    var listOfFavorites: [SavedFavorites] = []
    //var listOfFavorites: [String] = []
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
        let databaseRef = FIRDatabase.database().reference().child("Users").child("Username").child("Favorites")
        username = "Lisa"
        
        let databaseHandle = databaseRef.observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                if let dbLocation = item as? FIRDataSnapshot {
                    
                    for item2 in dbLocation.children {
                        
                        
                        /*
                        I think initalizing these objects here is messing with the same initalized objects in the userFavorites class. However, because the scope of the favoriteLocation, lat Coord, and longCoord are so small, they are otherwise unaccessible.
                        var latCoordName: String?
                        var latCoord: Double?
                        var longCoordName: String?
                        var longCoord: Double?
                        var favoriteLocation: String?
                        var latString: String?
                        var longString: String?
                        var savedLatCoord: Double?
                        */
                        var updatedLocation = ""
                        var updatedLat = Double()
                        var updatedLong = Double()
                        
                        
                        
                        if let pair = item2 as? FIRDataSnapshot {
                            
                            
                            if let location = pair.value as? String {
                            
                                if let favoriteLocation = location as? String {
                                    //self.listOfFavorites.append(favoriteLocation)
                                    let updatedLocation = SavedFavorites(location: favoriteLocation)
                                    //print (favoriteLocation)
                                }
                            } else if let value = pair.value as? Double? {
                                
                                let valueName = pair.key as? String
                                
                                if valueName == "Latitude" {
                                    if let latCoordName = valueName {
                                        if let latCoord = value {
                                            let latString = ("\(latCoordName) \(latCoord)")
                                            let savedLatCoord = latCoord
                                            //self.listOfFavorites.append(latString)
                                            let updatedLat = SavedFavorites(latCoord: latCoord)
                                            //print (latString)
                                        }
                                    }
                                } else {
                                    if let longCoordName = valueName {
                                        if let longCoord = value {
                                            let longString = ("\(longCoordName) \(longCoord)")
                                            //self.listOfFavorites.append(longString)
                                            let updatedLong = SavedFavorites(longCoord: longCoord)
                                            //print (longString)
                                        }
                                    }
                                }
                                /*
                                Tried to create a new object newFavorite, which is of type SavedFavorites, with variables declared outside the scope of the if statements, to avoid the error message 'SavedFavorites' has no member type ... But it is printing Optional(0.0), which means it's not saving properly, and it's still an optional. Can't use an if let on this statment as SavedFavorites is not an optional type.
                                let newFavorite = SavedFavorites(latCoord: updatedLat, longCoord: updatedLong, location: updatedLocation)
                                print(newFavorite.latCoord)
                                self.listOfFavorites.append(newFavorite)
                                */
                            }
                            //append objects to the array.
                        }
                        //use the array to populate table view.
                    }
                    print("===")
                    
                }
                
            }
            //print("\"===\(self.listOfFavorites)")
            //print(self.listOfFavorites.latCoord)
            /*
            //I can't seem to access listOfFavorites.latCoord, etc, because it says value of type [SavedFavorites] has no member latCoord. Even though it does
            //By doing the below, I'm trying to see if these values are being saved into listOfFavorites. It prints Optional(nil), so it isn't.
            for favorite in self.listOfFavorites {
                print (favorite.latCoord as? Double?)
                print (favorite.longCoord as? Double?)
                print (favorite.location as? String?)
            }
            */
        })
        
        
        tableView.reloadData()
        
        let moveButton = UIBarButtonItem(title: "Re-order", style: .plain, target: self, action: #selector(FavoriteLocationsTableViewController.toggleEdit))
        navigationItem.leftBarButtonItem = moveButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FavoriteLocationsTableViewController.addNewFavorite))
        navigationItem.rightBarButtonItem = addButton
    }
    
    /*
    func addFavorite(tuple: (lat: Double, long: Double, location: String)) {
        let newLatCoord = tuple.lat
        let newLongCoord = tuple.long
        let newLocation = tuple.location
        
        let newFavorite = SavedFavorites(latCoordName: newLatCoord, longCoordName: newLongCoord, location: newLocation)
        
        self.listOfFavorites.append(newFavorite)
        
        let newIndexPath = IndexPath(row: self.listOfFavorites.count -1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        /*
        let favorite = self.listOfFavorites[indexPath.row]
    
        if let locationName = favorite.location {
            
            //cell.textLabel?.text = self.listOfFavorites[indexPath.row]
        }
        */
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
