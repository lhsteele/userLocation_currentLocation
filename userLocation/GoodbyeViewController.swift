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
        
        view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        label.textColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
