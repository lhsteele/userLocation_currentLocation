//
//  GoodbyeViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 7/21/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import ChameleonFramework

class GoodbyeViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = FlatTeal()
        label.textColor = FlatWhite()
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
