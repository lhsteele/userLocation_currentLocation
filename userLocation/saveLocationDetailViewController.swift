//
//  saveLocationDetailViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 1/17/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class saveLocationDetailViewController: UIViewController {
    
    @IBOutlet var locationNameField: UITextField!
    @IBOutlet var locationCoordinates: UILabel!
    
    var locationName = String.self
    var coordinatesPassed = ""
    
  

    override func viewDidLoad() {
        super.viewDidLoad()

        locationCoordinates.text = coordinatesPassed
        
        print(coordinatesPassed)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

    
