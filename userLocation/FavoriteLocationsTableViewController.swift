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
    var username = ""
    var databaseHandle: FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        let moveButton = UIBarButtonItem(title: "Re-order", style: .plain, target: self, action: #selector(FavoriteLocationsTableViewController.toggleEdit))
        navigationItem.leftBarButtonItem = moveButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FavoriteLocationsTableViewController.addNewFavorite))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func loadData () {
        let databaseRef = FIRDatabase.database().reference().child("Locations")
        username = "Lisa"
    
        let databaseHandle = databaseRef.observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                var updatedLocation = ""
                var updatedLat = Double()
                var updatedLong = Double()
                var updatedUser = Int()
                var updatedUserArray = [Int] ()
                
                
                if let dbLocation = item as? FIRDataSnapshot {
                    
                    for item2 in dbLocation.children {
                        
                        if let pair = item2 as? FIRDataSnapshot {
                            
                            //'always suceeds' error means an unnecessary level of casting.
                            
                            if let location = pair.value as? String {
                                
                                updatedLocation = location
                                
                                
                            } else if let value = pair.value as? Double {
                                
                                let valueName = pair.key
                                
                                if valueName == "Latitude" {
                                    updatedLat = value
                                } else {
                                    updatedLong = value
                                }
                            
                            } else {
                            
                                if let value = pair.value as? Int {
                                
                                    updatedUser = value
                                    print (updatedUser)
                                }
                            }
  
                        }

                    }
                    
                }
                let newFavorite = SavedFavorites(latCoord: updatedLat, longCoord: updatedLong, location: updatedLocation)
                self.listOfFavorites.append(newFavorite)
                updatedUserArray.append(updatedUser)
                print("\"===\(updatedUserArray)")
            }
            //print("\"===\(self.listOfFavorites)")
            self.tableView.reloadData()
        })
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let favorite = self.listOfFavorites[indexPath.row]
    
        cell.textLabel?.text = favorite.location
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        
    }
    
  
    
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
