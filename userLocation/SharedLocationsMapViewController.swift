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


class SharedLocationsMapViewController: UIViewController, CLLocationManagerDelegate {

    
    var listOfSharedFavorites: [SavedFavorites] = []
    var locationID = ""
    var fireUserID = String()
    var locationName = String()
    var locationLat = CLLocationDegrees()
    var locationLong = CLLocationDegrees()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (locationID)
        
        getLocationCoordinates()

        // Do any additional setup after loading the view.
    }
    
    /*
    let manager = CLLocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let sharedFavLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(sharedFavLocation, span)
        
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
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
                                        self.locationLat = sharedLat as CLLocationDegrees
                                        print (self.locationLat)
                                    } else {
                                        sharedLong = value as CLLocationDegrees
                                        self.locationLong = sharedLong as CLLocationDegrees
                                    }
                                }
                            }

                        }
                    }
                    var sharedLocToMap = CLLocationCoordinate2D(latitude: self.locationLat, longitude: self.locationLong)
                    print (sharedLocToMap)
                }
                
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
