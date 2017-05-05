//
//  FavLocMapViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/5/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class FavLocMapViewController: UIViewController {
    
    var locationID = ""
    var locationLat = CLLocationDegrees()
    var locationLong = CLLocationDegrees()
    var favLocToMap = CLLocationCoordinate2D()
    var annotation = MKPointAnnotation()

    @IBOutlet var favLocMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        getLocationCoordinates()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMap() {
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(favLocToMap, span)
        
        favLocMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = favLocToMap
        print (favLocToMap)
        annotation.title = ""
        
        favLocMap.addAnnotation(annotation)
        favLocMap.showAnnotations([annotation], animated: true)
        
    }
    
    
    func getLocationCoordinates() {
        let databaseRef = FIRDatabase.database().reference().child("Locations").queryOrderedByKey()
        
        _ = databaseRef.queryEqual(toValue: locationID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                var favLocation = ""
                var favLat = Double()
                var favLong = Double()
                
                if let dbLocation = item as? FIRDataSnapshot {
                    
                    for item in dbLocation.children {
                        
                        if let pair = item as? FIRDataSnapshot {
                            if let location = pair.value as? String {
                                favLocation = location
                            } else {
                                if let value = pair.value as? Double {
                                    let valueName = pair.key
                                    
                                    if valueName == "Latitude" {
                                        
                                        favLat = value as CLLocationDegrees
                                        self.locationLat = favLat as CLLocationDegrees
                                        
                                    } else {
                                        favLong = value as CLLocationDegrees
                                        self.locationLong = favLong as CLLocationDegrees
                                    }
                                }
                            }
                            
                        }
                    }
                    let favCoordinate = CLLocationCoordinate2DMake(self.locationLat, self.locationLong)
                    self.favLocToMap = favCoordinate
                }
                
            }
            self.showMap()
        })
    }

    
}
