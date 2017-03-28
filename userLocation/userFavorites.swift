//
//  userFavorites.swift
//  userLocation
//
//  Created by Lisa Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit


class SavedFavorites: NSObject {
    var latCoord: Double
    var longCoord: Double
    var location: String
    
    init(latCoord: Double, longCoord: Double, location: String) {
        self.latCoord = latCoord
        self.longCoord = longCoord
        self.location = location
    
        super.init()
    }
}


    
