//
//  JourneyLocations.swift
//  userLocation
//
//  Created by Lisa Steele on 6/19/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class JourneyLocation: NSObject {
    var userID: String
    var currentLat: Double
    var currentLong: Double
    var destinationLat: Double
    var destinationLong: Double
    
    init(userID: String, currentLat: Double, currentLong: Double, destinationLat: Double, destinationLong: Double) {
        self.userID = userID
        self.currentLat = currentLat
        self.currentLong = currentLong
        self.destinationLat = destinationLat
        self.destinationLong = destinationLong
        
        super.init()
    }
    
}
