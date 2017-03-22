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
    var favoriteLocation: String?
    
    
    init(latCoord: String? = nil, longCoord: String? = nil, favoriteLocation: String? = nil) {
        self.favoriteLocation = favoriteLocation
        self.latCoord = latCoord
        self.longCoord = longCoord
        
        super.init()
    }
}


    
