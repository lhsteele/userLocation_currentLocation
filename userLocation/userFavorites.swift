//
//  userFavorites.swift
//  userLocation
//
//  Created by Lisa Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import MapKit


class SavedFavorites: NSObject, MKAnnotation {
    var location: String?
    var coordinate: CLLocationCoordinate2D
    
    
    init(location: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.location = location
        self.coordinate = coordinate
        super.init()
    }
}

    
