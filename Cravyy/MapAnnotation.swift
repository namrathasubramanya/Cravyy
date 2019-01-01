//
//  MapAnnotation.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/17/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
