//
//  ViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 1/9/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase



class ViewController: UIViewController, CLLocationManagerDelegate, UITabBarDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var createAFavoriteLocation: UIButton!

    var latCoord = CLLocationDegrees()
    var longCoord = CLLocationDegrees()
    var latCoordPassed = CLLocationDegrees()
    var longCoordPassed = CLLocationDegrees()
    var temporaryString = ""
    var handle: FIRAuthStateDidChangeListenerHandle?
    var fireUserID = String()
    var test = String()
    var passedFireUserID = String()
    
    
    
    let manager = CLLocationManager ()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
    }
    
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()        
        manager.startUpdatingLocation()
     
    }
    
    @IBAction func saveUserFavorite(_ sender: Any) {
        if let location = manager.location {
            
            
            let localValue: CLLocationCoordinate2D = location.coordinate
            
            let latCoord = localValue.latitude
            let longCoord = localValue.longitude
            
            latCoordPassed = latCoord
            longCoordPassed = longCoord
            
        }
      
        performSegue(withIdentifier: "SaveLocationDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SaveLocationDetailSegue") {

            let pointer = segue.destination as! SaveLocationDetailViewController
            
            pointer.latCoordPassed = self.latCoordPassed
            pointer.longCoordPassed = self.longCoordPassed
            pointer.fireUserID = self.fireUserID
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }

    
}



