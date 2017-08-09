//
//  userFavorites.swift
//  userLocation
//
//  Created by Lisa Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class SavedFavorites: NSObject {
    var latCoord: Double
    var longCoord: Double
    var location: String
    var userID: String
    
    
    init(latCoord: Double, longCoord: Double, location: String, userID: String) {
        self.latCoord = latCoord
        self.longCoord = longCoord
        self.location = location
        self.userID = userID
    
        super.init()
    }
    
}
