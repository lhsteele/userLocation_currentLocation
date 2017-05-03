//
//  SharedLocationsMapViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/2/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class SharedLocationsMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    var listOfSharedFavorites: [SavedFavorites] = []
    var locationID = ""
    var fireUserID = String()
    var locationName = String()
    var locationLat = CLLocationDegrees()
    var locationLong = CLLocationDegrees()
    var sharedLocToMap = CLLocationCoordinate2D()
    var annotation = MKPointAnnotation()
    
    @IBOutlet var sharedLocMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (locationID)
        
        getLocationCoordinates()
        
        var span = MKCoordinateSpanMake(0.01, 0.01)
        var region = MKCoordinateRegionMake(sharedLocToMap, span)
        
        sharedLocMap.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = sharedLocToMap
        annotation.title = ""
        
        sharedLocMap.addAnnotation(annotation)

    }
    
    /*
    let manager = CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        //let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(sharedLocToMap, span)
        
        sharedLocMap.setRegion(region, animated: true)
        
        self.sharedLocMap.showsUserLocation = true
    }
    */
   
    
    
    func getLocationCoordinates() {
        let databaseRef = FIRDatabase.database().reference().child("Locations").queryOrderedByKey()
        
        _ = databaseRef.queryEqual(toValue: locationID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                var sharedLocation = ""
                var sharedLat = Double()
                var sharedLong = Double()
                
                if let dbLocation = item as? FIRDataSnapshot {
                    print (dbLocation)
                    for item in dbLocation.children {
                        
                        if let pair = item as? FIRDataSnapshot {
                            if let location = pair.value as? String {
                                sharedLocation = location
                            } else {
                                if let value = pair.value as? Double {
                                    let valueName = pair.key
                                    
                                    if valueName == "Latitude" {
                                        
                                        sharedLat = value
                                        self.locationLat = sharedLat //as CLLocationDegrees
                                        print (self.locationLat)
                                    } else {
                                        sharedLong = value as CLLocationDegrees
                                        self.locationLong = sharedLong //as CLLocationDegrees
                                    }
                                }
                            }

                        }
                    }
                    sharedLocToMap = (latitude: self.locationLat, longitude: self.locationLong)
                    print (self.sharedLocToMap)
                }
                
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
