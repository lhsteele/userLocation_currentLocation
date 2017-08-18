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



class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var createAFavoriteLocation: UIButton!
    @IBOutlet var addressTextField: UITextField!
    
    

    var latCoord = CLLocationDegrees()
    var longCoord = CLLocationDegrees()
    var latCoordPassed = CLLocationDegrees()
    var longCoordPassed = CLLocationDegrees()
    var textInputLat = CLLocationDegrees()
    var textInputLong = CLLocationDegrees()
    var temporaryString = ""
    var handle: AuthStateDidChangeListenerHandle?
    var fireUserID = String()
    var test = String()
    var passedFireUserID = String()
    var listOfSharedFavorites: [SavedFavorites] = []
    var locationID = ""
    var inputAddressCoordinates = CLLocationCoordinate2D()
    var resultSearchController: UISearchController? = nil

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
        
        let localValue: CLLocationCoordinate2D = location.coordinate
        
        let latCoord = localValue.latitude
        let longCoord = localValue.longitude
        
        latCoordPassed = latCoord
        longCoordPassed = longCoord
    }
 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        map.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        addressTextField.returnKeyType = UIReturnKeyType.done
        self.addressTextField.delegate = self
        
        createAFavoriteLocation.setTitleColor(UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0), for: UIControlState.normal)
        createAFavoriteLocation.layer.borderColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0).cgColor
        createAFavoriteLocation.layer.borderWidth = 1
        createAFavoriteLocation.layer.cornerRadius = 10
        createAFavoriteLocation.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "SearchTable") as! SearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for location"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = map
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: (reuseID))
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func plotInputAddress() {
        let geocoder = CLGeocoder()
        _ = MKPointAnnotation()
        let inputAddress = addressTextField.text!
        geocoder.geocodeAddressString(inputAddress) { (placemarks, error) in
            let placemark = placemarks?.first
            if let inputLat = placemark?.location?.coordinate.latitude, let inputLong = placemark?.location?.coordinate.longitude {
                self.latCoordPassed = inputLat
                self.longCoordPassed = inputLong
                let coordMaker = CLLocationCoordinate2DMake(inputLat, inputLong)
                self.inputAddressCoordinates = coordMaker
            }
            self.showInputAddressOnMap()
        }
        
    }
    
    func showInputAddressOnMap() {
        print ("inputAddressCoordinates \(inputAddressCoordinates)")
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(inputAddressCoordinates, span)
        
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = inputAddressCoordinates
        annotation.title = addressTextField.text
        
        map.addAnnotation(annotation)
        map.showAnnotations([annotation], animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        if addressTextField != nil {
            self.plotInputAddress()
        }
        return true
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



