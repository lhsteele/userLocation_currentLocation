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



class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
    var listOfSharedFavorites: [SavedFavorites] = []
    var locationID = ""
    
    
    
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
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        print ("MapView\(fireUserID)")
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 2.0
        map.addGestureRecognizer(longPressGestureRecognizer)
        self.action(gestureRecognizer: longPressGestureRecognizer)
    }
    
    func action(gestureRecognizer: UIGestureRecognizer) {
        
        let touchPoint = gestureRecognizer.location(in: map)
        let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        map.addAnnotation(annotation)
        latCoordPassed = newCoordinates.latitude
        longCoordPassed = newCoordinates.longitude
        print ("lat \(latCoordPassed)")
        print ("long \(longCoordPassed)")
    }
    
    @IBAction func saveUserFavorite(_ sender: Any) {
      
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



