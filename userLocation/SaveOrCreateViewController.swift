//
//  SaveOrCreateViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 3/31/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase

class SaveOrCreateViewController: UIViewController {
    
    @IBOutlet var saveFavoriteButton: UIButton!
    
    @IBOutlet var createALink: UIButton!
    
    var handle: FIRAuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveNewFavorite(_ sender: Any) {
        performSegue(withIdentifier: "MapViewSegue", sender: sender)
        
    }
    
    @IBAction func createNewLink(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }

        
}
