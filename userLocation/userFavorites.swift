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
    var favoriteLocation: String?
    
    
    init(latCoord: Double? = nil, latCoordName: String? = nil, longCoord: Double? = nil, longCoordName: String? = nil, favoriteLocation: String? = nil) {
        self.latCoord = latCoord
        self.latCoordName = latCoordName
        self.longCoord = longCoord
        self.longCoordName = longCoordName
        self.favoriteLocation = favoriteLocation
    
        super.init()
    }
}


    
