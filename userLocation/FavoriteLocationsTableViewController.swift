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
                         var latCoordName: String?
                         var latCoord: Double?
                         var longCoordName: String?
                         var longCoord: Double?
                         var favoriteLocation: String?
                         */
                        
                        if let pair = item2 as? FIRDataSnapshot {
                            
                            
                            if let location = pair.value as? String {
                                
                                if let favoriteLocation = location as? String {
                                    print (favoriteLocation)
                                    self.listOfFavorites.append(favoriteLocation)
                                    print ("\"===\(self.listOfFavorites)")
                                }
                            } else if let value = pair.value as? Double? {
                                
                                let valueName = pair.key as? String
                                
                                if valueName == "Latitude" {
                                    if let latCoordName = valueName {
                                        if let latCoord = value {
                                            print ("\(latCoordName)\(latCoord)")
                                        }
                                    }
                                } else {
                                    if let longCoordName = valueName {
                                        if let longCoord = value {
                                            print ("\(longCoordName)\(longCoord)")
                                        }
                                    }
                                }
                            }
                            //append objects to the array.
                            
                        }
                        
                        
                        
                        //use the array to populate table view.
                    }
                    print("===")
                    
                }
                
            }
            
            
        })
        
        tableView.reloadData()
        
        let moveButton = UIBarButtonItem(title: "Re-order", style: .plain, target: self, action: #selector(FavoriteLocationsTableViewController.toggleEdit))
        navigationItem.leftBarButtonItem = moveButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FavoriteLocationsTableViewController.addNewFavorite))
        navigationItem.rightBarButtonItem = addButton
    }
 
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        /*
        let favorite = self.listOfFavorites[indexPath.row]
    
        if let locationName = favorite.location {
            
            cell.textLabel?.text = locationName
        }
        */
        
        //cell.textLabel?.text = listOfFavorites[indexPath.row]
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
