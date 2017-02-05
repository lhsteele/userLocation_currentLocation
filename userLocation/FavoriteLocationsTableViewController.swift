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
		// e.g. storedLocation = "12;23;work+13;45;home"
        let storedLocations =  defaults.string(forKey: favoriteLocationKey)
		
		/*
		e.g. locations = ["12;23;work", "13;45;home"]
		*/
        if let locations = storedLocations?.components(separatedBy: "+") {
			
			for location in locations {
				
				let locationComponents = location.components(separatedBy: ";")
				let s = SavedFavorites(latCoord: locationComponents[0],
									   longCoord: locationComponents[1],
									   location: locationComponents[2])
	//			thirdAddFavourite(location: s)
				listOfFavorites.append(s)
			}
        }
		// After adding all the object to our listOfFavorites
		// array, we can reload the table view
		tableView.reloadData()
		
        
 
        /*
        let components = favoriteLocations?.components(separatedBy: ";")
        
        var output = [(lat: String, long: String, location: String)] ()
        
        for component in components {
            if !component.isEmpty {
                
                let subComponents = component.components(separatedBy: ";")
                print (subComponents)
         
                let tuple = (lat: subComponents[0], long: subComponents[1], location: subComponents[2])
         
                print (tuple)
                output.append(tuple)
            }
        }
        print (output)
        */
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	
	// We define a addFavorite(tuple:) function that takes a tuple as
	// an argument. This function is defined here, inside the
	// FavoriteLocationsTableViewController class, at the same level
	// as all the other functions.

	func secondAddFavorite(lat: String, long:String, location: String) {
		
		let newFavourite = SavedFavorites(latCoord: lat, longCoord: long, location: location)
	}
	
	func thirdAddFavourite(location: SavedFavorites) {
		
		
	}
	
	// Once defined, we can use it above, on line 37.
	func addFavorite(tuple: (lat: String, long:String, location: String)) {
		
		// We instantiate a new object of type SavedFavourites
		let newFavourite = SavedFavorites(latCoord: tuple.lat, longCoord: tuple.long, location: tuple.location)
		// only now, this new object of type SavedFavourites
		// to which the constant newFavourite points to
		// can be added to our array.
		self.listOfFavorites.append(newFavourite)
		// Remember, all the elements of listOfFavorites
		// need to be of type SavedFavorites.
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
    */
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listOfFavorites.count
    }
   
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
