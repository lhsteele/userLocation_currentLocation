//
//  SharedLocationsTableViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/1/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class SharedLocationsTableViewController: UITableViewController {
    
    var fireUserID = String()
    var listOfSharedFavorites: [SavedFavorites] = []
    var listOfSharedLocations = [String]()
    var locationID = ""
    var userFavToDelete = String()

    @IBOutlet var backButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        loadSharedLocations()
        print ("sharedLocationsTVC\(fireUserID)")
    }
    
    func loadSharedLocations() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            
            let locationKey = ref.child("SharedLocations").child(userID)
            
            locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let sharedLocations = snapshot.children
                
                for item in sharedLocations {
                    if let pair = item as? FIRDataSnapshot {
                        if let locID = pair.value as? String {
                            self.locationID = locID
                            print (self.locationID)
                        }
                    }
                    self.listOfSharedLocations.append(self.locationID)
                }
                self.loadSharedData()
            })
        }
    }
    
    func loadSharedData () {
        print ("loadSharedDataRun")
        for item in listOfSharedLocations {
            
            let databaseRef = FIRDatabase.database().reference().child("Locations").queryOrderedByKey()
            _ = databaseRef.queryEqual(toValue: item).observe(.value, with: { (snapshot) in
                
                for item2 in snapshot.children {
                    
                    var updatedLocation = ""
                    var updatedLat = Double()
                    var updatedLong = Double()
                    
                    if let dbLocation = item2 as? FIRDataSnapshot {
                        
                        for item2 in dbLocation.children {
                            
                            if let pair = item2 as? FIRDataSnapshot {
                                
                                if let location = pair.value as? String {
                                    
                                    updatedLocation = location
                                    
                                } else {
                                    
                                    if let value = pair.value as? Double {
                                        
                                        let valueName = pair.key
                                        
                                        if valueName == "Latitude" {
                                            updatedLat = value
                                            print ("SLTV\(updatedLat)")
                                        } else {
                                            updatedLong = value
                                            print ("SLTV\(updatedLong)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let newFavorite = SavedFavorites(latCoord: updatedLat, longCoord: updatedLong, location: updatedLocation, userID: self.fireUserID)
                    self.listOfSharedFavorites.append(newFavorite)
                }
                self.tableView.reloadData()
            })
        }
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listOfSharedFavorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let sharedFav = self.listOfSharedFavorites[indexPath.row]
        
        cell.textLabel?.text = sharedFav.location

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            
            self.listOfSharedFavorites.remove(at: indexPath.row)
            
            self.userFavToDelete = self.listOfSharedLocations[indexPath.row] as String
            
            let deletionRef = FIRDatabase.database().reference().child("SharedLocations").child(uid)
            
            deletionRef.observeSingleEvent(of: .value, with: { (snapshot) in
                for snap in snapshot.children {
                    let keySnap = snap as! FIRDataSnapshot
                    if keySnap.value as! String == self.userFavToDelete {
                        keySnap.ref.removeValue()
                    }
                }
            })
            
            self.listOfSharedLocations.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        performSegue(withIdentifier: "ShowSharedLocationSegue", sender: self)
        
    }
    
    
    func deleteFromLocationsDB() {
        let locDeletionRef = FIRDatabase.database().reference().child("Locations")
        
        let locToDeleteRef = locDeletionRef.child(userFavToDelete)
        locToDeleteRef.removeValue()
    }
    
    @IBAction func backToFavorites(_ sender: Any) {
        performSegue(withIdentifier: "BackToFavoritesSegue", sender: backButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowSharedLocationSegue") {
            let pointer = segue.destination as! SharedLocationsMapViewController
            
            pointer.locationID = self.locationID
            pointer.fireUserID = self.fireUserID
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
