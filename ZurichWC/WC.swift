//
//  WC.swift
//  ZurichWC
//
//  Created by Josep Lopez Fernandez on 24.09.17.
//  Copyright © 2017 Josep Lopez Fernandez. All rights reserved.
//

import Foundation
import MapKit

struct WC {
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
