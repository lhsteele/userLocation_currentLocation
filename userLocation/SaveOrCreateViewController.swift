//
//  SaveOrCreateViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 3/31/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class SaveOrCreateViewController: UIViewController {
    
    @IBOutlet var saveFavoriteButton: UIButton!
    
    @IBOutlet var createALink: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
}
