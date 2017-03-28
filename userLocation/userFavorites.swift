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
    //var latCoordName: String?
    var longCoord: Double
    //var longCoordName: String?
    var location: String
    
    
    init(latCoord: Double, longCoord: Double, location: String) {
        self.latCoord = latCoord
        //self.latCoordName = latCoordName
        self.longCoord = longCoord
        //self.longCoordName = longCoordName
        self.location = location
    
        super.init()
    }
}


    
