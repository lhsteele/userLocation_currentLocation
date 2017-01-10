//
//  userFavorites.swift
//  userLocation
//
//  Created by Lisa Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class userFavorites: NSObject {
    var location: String?
    var coordinate: Double?
    
    
    init(location: String? = nil, coordinate: Double? = nil, stringOfCoordinate: String? = nil) {
        self.location = location
        self.coordinate = coordinate
        super.init()
    }
    
 

}

    
