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
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        getLocationCoordinates()
        //showMap()
        
    }
    
    func showMap() {
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(sharedLocToMap, span)
        
        sharedLocMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = sharedLocToMap
        print (sharedLocToMap)
        annotation.title = ""
        
        sharedLocMap.addAnnotation(annotation)
        sharedLocMap.showAnnotations([annotation], animated: true)

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
                    
                    for item in dbLocation.children {
                        
                        if let pair = item as? FIRDataSnapshot {
                            if let location = pair.value as? String {
                                sharedLocation = location
                            } else {
                                if let value = pair.value as? Double {
                                    let valueName = pair.key
                                    
                                    if valueName == "Latitude" {
                                        
                                        sharedLat = value as CLLocationDegrees
                                        self.locationLat = sharedLat as CLLocationDegrees
                                        
                                    } else {
                                        sharedLong = value as CLLocationDegrees
                                        self.locationLong = sharedLong as CLLocationDegrees
                                    }
                                }
                            }

                        }
                    }
                    let sharedCoordinate = CLLocationCoordinate2DMake(self.locationLat, self.locationLong)
                    self.sharedLocToMap = sharedCoordinate
                }
                
            }
            self.showMap()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
