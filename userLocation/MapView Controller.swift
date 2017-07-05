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
import Firebase



class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var createAFavoriteLocation: UIButton!

    var latCoord = CLLocationDegrees()
    var longCoord = CLLocationDegrees()
    var latCoordPassed = CLLocationDegrees()
    var longCoordPassed = CLLocationDegrees()
    var temporaryString = ""
    var handle: FIRAuthStateDidChangeListenerHandle?
    var fireUserID = String()
    var test = String()
    var passedFireUserID = String()
    var listOfSharedFavorites: [SavedFavorites] = []
    var locationID = ""


    let manager = CLLocationManager ()
    let geocoder = CLGeocoder()
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
    }
 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        map.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        print ("MapView\(fireUserID)")
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 2.0
        map.addGestureRecognizer(longPressGestureRecognizer)
        self.action(gestureRecognizer: longPressGestureRecognizer)
        
    }
    
    func action(gestureRecognizer: UIGestureRecognizer) {
        
        let touchPoint = gestureRecognizer.location(in: map)
        let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
        var locationName = String()
        var locationStreet = String()
        
        latCoordPassed = newCoordinates.latitude
        longCoordPassed = newCoordinates.longitude
        print ("lat \(latCoordPassed)")
        print ("long \(longCoordPassed)")
        
        let location = CLLocation(latitude: latCoordPassed, longitude: longCoordPassed)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let address = placemark.thoroughfare, let name = placemark.name {
                locationName = address
                locationStreet = name
            }
            annotation.coordinate = newCoordinates
            annotation.title = locationName
            print (locationName)
            annotation.subtitle = locationStreet
            print (locationStreet)
        }
        
        map.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: (reuseID))
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
            annotationView?.isDraggable = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
    @IBAction func saveUserFavorite(_ sender: Any) {
      
        performSegue(withIdentifier: "SaveLocationDetailSegue", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SaveLocationDetailSegue") {

            let pointer = segue.destination as! SaveLocationDetailViewController
            
            pointer.latCoordPassed = self.latCoordPassed
            pointer.longCoordPassed = self.longCoordPassed
            pointer.fireUserID = self.fireUserID
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
}



