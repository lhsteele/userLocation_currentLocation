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
   
    
    var locationName = String.self
    var locationCoordinates = String
    
  

    override func viewDidLoad() {
        super.viewDidLoad()

        if let newLocationCoordinates = self.locationCoordinates {
            let saveTheseCoordinates = newLocationCoordinates.coordinate
        }
        
        print(locationCoordinates)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

    
