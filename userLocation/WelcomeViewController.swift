//
//  WelcomeViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/4/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector (self.tapAction (_:)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LoginSegue") {
            
            let pointer = segue.destination as! LoginViewController
        }
    }
    
    func tapAction(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    

}
