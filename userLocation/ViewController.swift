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
    @IBOutlet weak var saveLocation: UIButton!

    @IBAction func saveUserFavorite(_ sender: Any) {
        if let location = manager.location {
            let localValue: CLLocationCoordinate2D = location.coordinate
            
            let lat: String = localValue.latitude.description
            let long: String = localValue.longitude.description
            let userFavorite = lat + ", " + long
            
            
            UserDefaults.standard.set(userFavorite, forKey: "favorite")
            UserDefaults.standard.synchronize()
            print ("Location Saved")
            
            var locationDictionary = dictionaryWithValues(forKeys: ["Home", "Work", "Gym", "School", "Daycare"])
            
            locationDictionary.updateValue(userFavorite, forKey: "Home")
            print (locationDictionary)
            
        
            var coordinates = [Any] ()
            
            if let favoriteLocation = UserDefaults.standard.object(forKey: "favorite") {
                coordinates.append(favoriteLocation)
                print (coordinates)
            
            }
            
        }
    
    }
    
    
    let manager = CLLocationManager ()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

