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
    @IBOutlet weak var createAFavoriteLocation: UIButton!

    var coordinatesArray = [(lat: Double, long: Double)] ()
    var storeValue = ""
    
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()        
        manager.startUpdatingLocation()
        
    }
    
    @IBAction func saveUserFavorite(_ sender: Any) {
        if let location = manager.location {
            
            
            let localValue: CLLocationCoordinate2D = location.coordinate
            
            let lat = localValue.latitude
            let long = localValue.longitude
         
            coordinatesArray.append((lat: lat, long: long))
            
            for coord in coordinatesArray {
                
                    let temporaryString = "\(coord.lat);\(coord.long)"
                
                    storeValue = temporaryString + ";"
            
            }
 
        }
        
        performSegue(withIdentifier: "saveLocationDetailSegue", sender: sender)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "saveLocationDetailSegue") {

            let pointer = segue.destination as! SaveLocationDetailViewController
            
            pointer.coordinatesPassed = storeValue
        }
    }
    
}



