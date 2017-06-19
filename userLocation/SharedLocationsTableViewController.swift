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

        //loadSharedLocations()
        print ("sharedLocationsTVC\(fireUserID)")
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
 

}
