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
    var location: String?
    var coordinate: String?
    
    init(location: String? = nil, coordinate: String? = nil) {
        self.location = location
        self.coordinate = coordinate
        super.init()
    }
}

    
