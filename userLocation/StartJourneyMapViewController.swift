//
//  StartJourneyMapViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/11/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import ChameleonFramework

class StartJourneyMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var startAJourneyMap: MKMapView!
    var journeyToStart = String()
    var localValue = CLLocationCoordinate2D()
    var fireUserID = String()
    var handle: AuthStateDidChangeListenerHandle?
    
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        startAJourneyMap.setRegion(region, animated: true)
        self.startAJourneyMap.showsUserLocation = true
        print (localValue)
        localValue = location.coordinate
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("viewDidLoad\(localValue)")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        self.navigationController?.navigationBar.tintColor = FlatWhite()
        
        displayShareAlertMessage(messageToDisplay: "Would you like to share this journey?")
        
        view.backgroundColor = FlatTeal()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayShareAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Share Journey?", message: messageToDisplay, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            self.performSegue(withIdentifier: "ShareJourneySegue", sender: self)
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            self.performSegue(withIdentifier: "ShareToFavoritesSegue", sender: self)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true, completion:nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShareJourneySegue") {
            let pointer = segue.destination as! ShareJourneyPickerViewController
            pointer.journeyToStart = self.journeyToStart
            pointer.localValue = self.localValue
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
