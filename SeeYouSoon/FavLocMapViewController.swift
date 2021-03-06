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
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet var favLocMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        getLocationCoordinates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showMap() {
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(favLocToMap, span)
        
        favLocMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = favLocToMap
        annotation.title = ""
        
        favLocMap.addAnnotation(annotation)
        favLocMap.showAnnotations([annotation], animated: true)
        
    }
    
    
    func getLocationCoordinates() {
        let databaseRef = Database.database().reference().child("Locations").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: locationID).observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                var favLat = Double()
                var favLong = Double()
                
                if let dbLocation = item as? DataSnapshot {
                    
                    for item in dbLocation.children {
                        
                        if let pair = item as? DataSnapshot {
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
                    let favCoordinate = CLLocationCoordinate2DMake(self.locationLat, self.locationLong)
                    self.favLocToMap = favCoordinate
                }
                
            }
            self.showMap()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func appDidEnterBackground(_application: UIApplication) {
        try! Auth.auth().signOut()
    }
    
}
