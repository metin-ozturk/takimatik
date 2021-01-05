//
//  SelectedLocation.swift
//  Takimatik
//
//  Created by Metin Öztürk on 27.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation
import CoreLocation

struct SelectedLocation: Equatable {
    var coordinate : CLLocationCoordinate2D
    var address : String
    
    static func == (lhs: SelectedLocation, rhs: SelectedLocation) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
