//
//  GuideViewController.swift
//  SeeYouSoon
//
//  Created by Lisa Steele on 9/4/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet var text: UITextView!
    @IBOutlet var closebutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        text.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        closebutton.setTitleColor(UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0), for: UIControlState.normal)
        closebutton.layer.borderColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0).cgColor
        closebutton.layer.borderWidth = 1
        closebutton.layer.cornerRadius = 10
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func closeReturnToFavs(_ sender: Any) {
        performSegue(withIdentifier: "GuideToFavSegue", sender: self)
    }
    

}
