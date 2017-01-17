//
//  ViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 1/9/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

//play around with Swifty to convert to String and back
//button from mapview needs to push to the Save a Favorite Location view
//when this view controller is pushed, lat and long saved. (RGB slider) add data to segue.
//here they will type in name of Location, save that.


import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var saveLocation: UIButton!

    var coordinatesArray = [(lat: Double, long: Double)] ()
    var storeValue = ""
    
    @IBAction func saveUserFavorite(_ sender: Any) {
        if let location = manager.location {
            let localValue: CLLocationCoordinate2D = location.coordinate
            
            let lat = localValue.latitude
            let long = localValue.longitude
            
            coordinatesArray.append((lat: lat, long: long))

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
        
        
        for coord in coordinatesArray {
            
            let temporaryString = "\(coord.lat)-\(coord.long)"
            
            storeValue += temporaryString + ";"
            
        }
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "saveLocationDetailSegue") {
                let saveLocationDetailViewController = segue.destination
                let newLocationCoordinates = self.storeValue
                let destination = segue.destination as! saveLocationDetailViewController
                destination.locationCoordinates = newLocationCoordinates
            }
        }


    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    }

