//
//  WCStore.swift
//  ZurichWC
//
//  Created by Josep Lopez Fernandez on 28.09.17.
//  Copyright © 2017 Josep Lopez Fernandez. All rights reserved.
//

import Foundation

struct WCStore: Decodable {
    var values: [WC] {
        return features.map { (feature) -> WC in
            let name = feature.properties.name
            let coordinates = feature.geometry.coordinates
            return WC(name: name, latitude: coordinates[1], longitude: coordinates[0])
        }
    }
    
    private let features: [Feature]
    
    private struct Feature: Decodable {
        let geometry: Geometry
        let properties: Properties
        
        struct Geometry: Decodable {
            let coordinates: [Double]
        }
        struct Properties: Decodable {
            let name: String
        }
    }
}
