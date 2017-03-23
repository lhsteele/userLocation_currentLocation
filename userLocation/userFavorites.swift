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
    var latCoord: Double?
    var latCoordName: String?
    var longCoord: Double?
    var longCoordName: String?
    var location: String?
    
    
    init(latCoord: Double? = nil, latCoordName: String? = nil, longCoord: Double? = nil, longCoordName: String? = nil, location: String? = nil) {
        self.latCoord = latCoord
        self.latCoordName = latCoordName
        self.longCoord = longCoord
        self.longCoordName = longCoordName
        self.location = location
    
        super.init()
    }
}


    
