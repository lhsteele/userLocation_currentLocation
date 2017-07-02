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

class LiveJourneysMapViewController: UIViewController, CLLocationManagerDelegate{
    
    var startingCoordinates = CLLocationCoordinate2D()
    var destinationCoordinates = CLLocationCoordinate2D()
    var startingLat = CLLocationDegrees()
    var startingLong = CLLocationDegrees()
    var destinationLat = CLLocationDegrees()
    var destinationLong = CLLocationDegrees()

    @IBOutlet var liveJourneyMap: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartingCoordinates()
        showMap()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMap() {
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(startingCoordinates, span)
        
        liveJourneyMap.setRegion(region, animated: true)
        
        //let annotationView: MKPinAnnotationView!
        let annotationPoint = MKPointAnnotation()
        
        annotationPoint.coordinate = startingCoordinates
        print ("startingCoordinates \(startingCoordinates)")
        //get location name
        annotationPoint.title = ""
        
        //annotationView = MKPinAnnotationView(annotation: annotationPoint, reuseIdentifier: "Annotation")
        
        liveJourneyMap.addAnnotation(annotationPoint)
        liveJourneyMap.showAnnotations([annotationPoint], animated: true)
        
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
    
    /*
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            print ("denied")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            manager.startUpdatingLocation()
        }
    }
    */
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        renderer.lineWidth = 5.0
        return renderer as! MKPolylineRenderer
    }
    
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
