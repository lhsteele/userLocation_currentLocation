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

    var coordinatesArray = [String] ()
    
    let manager = CLLocationManager ()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
    }
    
    @IBAction func saveUserFavorite(_ sender: Any) {
        if let location = manager.location {
            let localValue: CLLocationCoordinate2D = location.coordinate
            
            let lat: String = localValue.latitude.description
            let long: String = localValue.longitude.description
            
            class savedFavorites: NSObject, MKAnnotation {
                var location: String?
                var coordinate: CLLocationCoordinate2D
                
                init(location: String? = nil, coordinate: CLLocationCoordinate2D) {
                    self.location = location
                    self.coordinate = coordinate
                    super.init()
                }
            }
            
            coordinatesArray.append(lat)
            coordinatesArray.append(long)
            
                        var favoriteCoordinatesArray = [Array<String>] ()
            
            favoriteCoordinatesArray.append(coordinatesArray)
            print(favoriteCoordinatesArray)
                
            }
            
        }
    
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

