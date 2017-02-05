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
	
    var latCoord: String?
    var longCoord: String?
    var location: String?
    
    init(latCoord: String? = nil, longCoord: String? = nil, location: String? = nil) {
        self.location = location
        self.latCoord = latCoord
        self.longCoord = longCoord
        
        super.init()
    }
}

    
