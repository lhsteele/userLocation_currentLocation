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
    
    //trying to attach a button to enact the "save" function. It says unresolved identifier, which I think means it's being used before it's been defined. But if I put these two IBActions after definition, within curly brackets, it says only instance methods can be declared as IBAction. So I put outside the curly brackets, but after the definition, and it still says unresolved identifier.
    @IBAction func saveUserFavorite(_ sender: Any) {
        if let location = manager.location {
            let localValue: CLLocationCoordinate2D = location.coordinate
            
            let lat: String = localValue.latitude.description
            let long: String = localValue.longitude.description
            let userFavorite = lat + ", " + long
            
            
            UserDefaults.standard.set(userFavorite, forKey: "favorite")
            UserDefaults.standard.synchronize()
            print ("Location Saved")
            
            let locations: [String] = ["Home"]
            var coordinates = [Any] ()
            
            if let favoriteLocation = UserDefaults.standard.object(forKey: "favorite") {
                coordinates.append(favoriteLocation)
                print (coordinates)
            }
            
        }
    
    }
    
    
    
    /*
    @IBAction func valueChangeEnded(_ sender: UIButton) {
        UserDefaults.standardUserDefaults().setFloat(userFavorite, forKey: "favorite")
    }
    */
    
    
    
    let manager = CLLocationManager ()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        //code below I think creates a variable called localValue which is made up of the current longitute and latitude. the two variables lat and long allow me to concatenate them into one variable called userFavorite
        //the reason I'm using variables and not constants is that I would like the user to be able to save more than one favorite location.
        //userDefaults commands below I think save the userFavorite variable.
        //print was simply to see if it was working.
        
        
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

