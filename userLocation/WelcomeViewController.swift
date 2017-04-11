//
//  WelcomeViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/4/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        let gestureRec = UITapGestureRecognizer(target: self, action: #selector (self.tapAction (_:)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func goToLogin(_ sender: Any) {
        
        
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }

}
