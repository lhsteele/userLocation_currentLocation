//
//  PopUpViewController.swift
//  SeeYouSoon
//
//  Created by Lisa Steele on 8/9/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet var popupView: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        closeButton.layer.borderColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0).cgColor
        closeButton.layer.cornerRadius = 10
        closeButton.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        label.textColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        popupView.layer.cornerRadius = 10
        self.showAnimate()
    }
    
    @IBAction func close(_ sender: Any) {
        self.removeAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished: Bool) in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        })
    }
}
