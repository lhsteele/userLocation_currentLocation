//
//  userFavorites.swift
//  userLocation
//
//  Created by Lisa Steele on 1/10/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class savedFavorites: NSObject {
    var location: Double?
    var coordinate: Double?
    
    
    init(location: Double? = nil, coordinate: Double? = nil) {
        self.location = location
        self.coordinate = coordinate
        super.init()
    }
    
 

}

    
