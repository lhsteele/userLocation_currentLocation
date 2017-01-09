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

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager ()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
    }
    
//this is the function called every time a user's location updates. Set a variable called "location", and set that equal to an array called "locations". We want the first element of the array, so the most recent position of our user.
//span. how much we want the map to be zoomed in on user's current location
//myLocation sets the user's current location
//region combines the user's location with the span, how much we can see.
//map.setRegion tells the map what to show, set animated to "true" to turn on
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

//desiredAccuracy/kCLocationAccuracyBest means we want to get the best accuracy of the user's current location
//requestWhenInUseAuthorization. Some apps want to get authorization for the app to track location in the background, but we only need to know their location when the app is in use.
//startUpdatingLocation. Calling a function every time the user's location is updated.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

