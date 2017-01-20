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
            
            let latString = String(lat)
            let longString = String(long)
            
            let stringCoord = "\(latString)-\(longString)"
            
            
            self.storeValue = stringCoord
            
            
            /*
            coordinatesArray.append((lat: lat, long: long))
            
            for coord in coordinatesArray {
                
                    let temporaryString = "\(coord.lat)-\(coord.long)"
                
                    storeValue = temporaryString + ";"
            
            }
            
            print(storeValue)
            
            print(coordinatesArray)
            */
        }
        
        performSegue(withIdentifier: "saveLocationDetailSegue", sender: sender)

    }
    
    func storeValueWorking () {
        print(storeValue)
    }
    
        //print(storeValue) in this function doesn't print to console.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "saveLocationDetailSegue") {

            let pointer = segue.destination as! saveLocationDetailViewController
            
            pointer.coordinatesPassed = self.storeValue
        }
    }
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
}



