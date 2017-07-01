//
//  LiveJourneysMapViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 7/1/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class LiveJourneysMapViewController: UIViewController {

    @IBOutlet var liveJourneyMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMap() {
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(<#T##centerCoordinate: CLLocationCoordinate2D##CLLocationCoordinate2D#>, span)
        
        
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
