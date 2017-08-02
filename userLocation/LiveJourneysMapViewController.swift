//
//  LiveJourneysMapViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 7/1/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class LiveJourneysMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var startingCoordinates = CLLocationCoordinate2D()
    var destinationCoordinates = CLLocationCoordinate2D()
    var startingLat = CLLocationDegrees()
    var startingLong = CLLocationDegrees()
    var destinationLat = CLLocationDegrees()
    var destinationLong = CLLocationDegrees()
    var destinationName = String()
    var today = String()
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet var liveJourneyMap: MKMapView!
    
    let manager = CLLocationManager()
    var movedToUserLocation = false
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveJourneyMap.delegate = self
        manager.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        
        getStartingCoordinates()
    }
    
    func plotOnMap() {
        
        
        print ("starting\(startingCoordinates)")
        print ("end\(destinationCoordinates)")
        
        let startLocation = startingCoordinates
        let destinationLocation = destinationCoordinates
        
        let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.title = "Current Location"
        
        if let location = startPlacemark.location {
            startAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        //need to write logic to retrieve destination location name from DB
        destinationAnnotation.title = destinationName
        
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.liveJourneyMap.showAnnotations([startAnnotation, destinationAnnotation], animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = startMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print ("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.liveJourneyMap.add(route.polyline)
            
            let rect = route.polyline.boundingMapRect
            self.liveJourneyMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            print ("Distance: \(route.distance), ETA: \(route.expectedTravelTime)")
            
            let seconds = route.expectedTravelTime
            let minutes = round(seconds / 60)
            print ("ETA in mins \(minutes)")
            destinationAnnotation.subtitle = "Estimated ETA : \(minutes) minutes"

        }
        
        
    }
   
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var annotationView = liveJourneyMap.dequeueReusableAnnotationView(withIdentifier: (reuseID))
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    func getStartingCoordinates() {
        let databaseRef = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("SharedWithLiveJourneys")
        
            if let userID = Auth.auth().currentUser?.uid {
                
                var currentLat = CLLocationDegrees()
                var currentLong = CLLocationDegrees()
                
                
                databaseRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let children = snapshot.children
                    
                    for item in children {
                        if let pair = item as? DataSnapshot {
                            if let childValue = pair.value as? CLLocationDegrees {
                                let childKey = pair.key /*as? String*/
                                if childKey == "CurrentLat" {
                                    currentLat = childValue as CLLocationDegrees
                                    self.startingLat = currentLat
                                } else if childKey == "CurrentLong" {
                                    currentLong = childValue as CLLocationDegrees
                                    self.startingLong = currentLong
                                }
                            }
                        }
                    }
                    let currentCoordinate = CLLocationCoordinate2DMake(self.startingLat, self.startingLong)
                    self.startingCoordinates = currentCoordinate
                    print (self.startingCoordinates)
                })
            }
        getDestinationCoordinates()
    }
    
    func getDestinationCoordinates() {
        let databaseRef = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("SharedWithLiveJourneys")
        
        if let userID = Auth.auth().currentUser?.uid {
            
            var endLat = CLLocationDegrees()
            var endLong = CLLocationDegrees()
            
            databaseRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let children = snapshot.children
                
                for item in children {
                    if let pair = item as? DataSnapshot {
                        if let childValue = pair.value as? CLLocationDegrees {
                            let childKey = pair.key /*as? String*/
                            if childKey == "DestinationLat" {
                                endLat = childValue as CLLocationDegrees
                                self.destinationLat = endLat
                            } else if childKey == "DestinationLong" {
                                endLong = childValue as CLLocationDegrees
                                self.destinationLong = endLong
                            }
                        }
                    }
                }
                let endCoordinate = CLLocationCoordinate2DMake(self.destinationLat, self.destinationLong)
                self.destinationCoordinates = endCoordinate
                print (self.destinationCoordinates)
                self.getDestinationLocationName()
            })
        }
    }
    
    func getDestinationLocationName() {
        let databaseRef = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("SharedWithLiveJourneys")
        if let userID = Auth.auth().currentUser?.uid {
            var name = String()
            
            databaseRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let children = snapshot.children
                
                for item in children {
                    if let pair = item as? DataSnapshot {
                        if let childValue = pair.value as? String {
                            let childKey = pair.key /*as? String*/
                            if childKey == "DestinationName" {
                                name = childValue as String
                                self.destinationName = name
                            }
                        }
                    }
                }
                self.plotOnMap()
            })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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
