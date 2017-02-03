//
//  favoriteLocationsTableViewController.swift
//  userLocation
//
//  Created by Lisa H Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

let favoriteLocationKey = "NewFavoriteLocation"

class FavoriteLocationsTableViewController: UITableViewController {
    
    // listOfFavorites is an array where each item inside
    // is of type SavedFavourites.
    // e.g.
    // listOfFavourites[0] is of type SavedFavourites, so
    // the following syntax is correct: listOfFavourites[0].latCoord
    // it would return a String? value.
    var listOfFavorites: [SavedFavorites] = []
    var components = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let favoriteLocations =  defaults.string(forKey: favoriteLocationKey)
        
        /*
        if let components = favoriteLocations?.components(separatedBy: ";") {
            let locationTuple = (lat: components[0], long: components[1], location: components[2])
            addFavorite(tuple: locationTuple)
            
            print(locationTuple)
        }
        */
        
        //need a for loop to loop through and separate by not just ";", but also "+"
        if let components = favoriteLocations?.components(separatedBy: "+") {
            for component in components {
                if let locationTuple = favoriteLocations?.components(separatedBy: ";") {
                    let singleLocation = (lat: components[0], long: components[1], location: components[2])
                    addFavorite(tuple: singleLocation)
                } else {
                    let locationTuple = favoriteLocations?.components(separatedBy: ";")
                }
            }
            //let locationTuple = (lat: components[0], long: components[1], location: components[2])
            
        }
        
        
        // After adding all the object to our listOfFavorites
        // array, we can reload the table view
        tableView.reloadData()
        
        let moveButton = UIBarButtonItem(title: "Re-order", style: .plain, target: self, action: #selector(FavoriteLocationsTableViewController.toggleEdit))
        navigationItem.leftBarButtonItem = moveButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FavoriteLocationsTableViewController.addNewFavorite))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    // We define a addFavorite(tuple:) function that takes a tuple as
    // an argument. This function is defined here, inside the
    // FavoriteLocationsTableViewController class, at the same level
    // as all the other functions.
    
    // Once defined, we can use it above, on line 37.
    func addFavorite(tuple: (lat: String, long:String, location: String)) {
        
        let newLatCoord = tuple.lat
        let newLongCoord = tuple.long
        let newLocation = tuple.location
        // The 3 contants from above are all of type String
        // and we can use them to instantiate a new object
        // of type SavedFavourites
        let newFavourite = SavedFavorites(latCoord: newLatCoord, longCoord: newLongCoord, location: newLocation)
        // only now, this new object of type SavedFavourites
        // to which the constant newFavourite points to
        // can be added to our array.
        self.listOfFavorites.append(newFavourite)
        // Remember, all the elements of listOfFavorites
        // need to be of type SavedFavorites.
        let newIndexPath = IndexPath(row: self.listOfFavorites.count - 1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let favorite = self.listOfFavorites[indexPath.row]
        
        // Wrong:
        //        if let locationName = listOfFavorites.location {
        //            cell.textLabel?.text = listOfFavorites.location
        //        } else {
        //            cell.textLabel?.text = ""
        //        }
        
        // Correct:
        // On line 97, we have created a constant pointing to
        // the item in an array for the current row. We
        // should use this constant from this point onward.
        if let locationName = favorite.location {
            
            // Since we unwrap the optional favourite.location
            // and assign the unwrapped value to locationName constant,
            // we should use this constant from that point onwards
            // inside this if.
            cell.textLabel?.text = locationName
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    func addNewFavorite(_ sender: Any?) {
        performSegue(withIdentifier: "AddNewFavoriteSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddNewFavoriteSegue") {
            let pThree = segue.destination as! ViewController
        }
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.listOfFavorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
