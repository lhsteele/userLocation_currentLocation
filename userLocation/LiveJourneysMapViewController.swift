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

    @IBOutlet var liveJourneyMap: MKMapView!
    
    let manager = CLLocationManager()
    var movedToUserLocation = false
    
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        liveJourneyMap.setRegion(region, animated: true)
        
        self.liveJourneyMap.showsUserLocation = true
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        getStartingCoordinates()
        
        
    }
    
    func plotOnMap() {
        
        liveJourneyMap.delegate = self
        manager.delegate = self
        
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
        //destinationAnnotation.title = ""
        
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
            self.liveJourneyMap.addOverlays((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.liveJourneyMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        renderer.lineWidth = 5.0
        return renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func showMap() {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(startingCoordinates, span)
        
        liveJourneyMap.setRegion(region, animated: true)
        
        let annotationView: MKPinAnnotationView!
        let annotationPoint = MKPointAnnotation()
        let secondAnnoPoint = MKPointAnnotation()
        
        annotationPoint.coordinate = startingCoordinates
        secondAnnoPoint.coordinate = destinationCoordinates
        print ("startingCoordinates \(startingCoordinates)")
        //get location name
        annotationPoint.title = ""
        
        annotationView = MKPinAnnotationView(annotation: annotationPoint, reuseIdentifier: "Annotation")
        
        liveJourneyMap.addAnnotation(annotationView.annotation!)
        //liveJourneyMap.addAnnotation(annotationPoint)
        //liveJourneyMap.showAnnotations([annotationPoint, secondAnnoPoint as! MKAnnotation], animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: startingCoordinates))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
        directionsRequest.requestsAlternateRoutes = false
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { (response, error) in
            if let res = response {
                if let route = res.routes.first {
                    self.liveJourneyMap.add(route.polyline)
                    self.liveJourneyMap.region.center = self.startingCoordinates
                }
            } else {
                print (error)
            }
        }
        /*
        directions.calculateETA { (etaResponse, error) in
            <#code#>
        }
        */
    }
    */
    
   
    
    func getStartingCoordinates() {
        let databaseRef = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("StartedJourneys")
        
            if let userID = FIRAuth.auth()?.currentUser?.uid {
                
                var currentLat = CLLocationDegrees()
                var currentLong = CLLocationDegrees()
                
                
                databaseRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let children = snapshot.children
                    
                    for item in children {
                        if let pair = item as? FIRDataSnapshot {
                            if let childValue = pair.value as? CLLocationDegrees {
                                let childKey = pair.key as? String
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
        let databaseRef = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/").child("StartedJourneys")
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            
            var endLat = CLLocationDegrees()
            var endLong = CLLocationDegrees()
            
            databaseRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let children = snapshot.children
                
                for item in children {
                    if let pair = item as? FIRDataSnapshot {
                        if let childValue = pair.value as? CLLocationDegrees {
                            let childKey = pair.key as? String
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
                self.showMap()
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
