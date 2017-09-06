//
//  GuideViewController.swift
//  SeeYouSoon
//
//  Created by Lisa Steele on 9/4/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet var step1Label: UILabel!
    @IBOutlet var step2Label: UILabel!
    @IBOutlet var step3Label: UILabel!
    @IBOutlet var step4Label: UILabel!
    
    @IBOutlet var step1Text: UITextView!
    @IBOutlet var step2Text: UITextView!
    @IBOutlet var step3aText: UITextView!
    @IBOutlet var step3bText: UITextView!
    @IBOutlet var step3cText: UITextView!
    @IBOutlet var step4Text: UITextView!
    
    @IBOutlet var closebutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closebutton.setTitleColor(UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0), for: UIControlState.normal)
        closebutton.layer.borderColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0).cgColor
        closebutton.layer.borderWidth = 1
        closebutton.layer.cornerRadius = 10
        
        step1Label.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step2Label.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step3Label.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step4Label.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step1Text.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step2Text.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step3aText.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step3bText.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step3cText.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        step4Text.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func closeReturnToFavs(_ sender: Any) {
        performSegue(withIdentifier: "GuideToFavSegue", sender: self)
    }
    

}
