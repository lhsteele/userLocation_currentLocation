//
//  GoodbyeViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 7/21/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class GoodbyeViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        label.textColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
