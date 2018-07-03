//
//  MapAnnotation.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-07-01.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
class MapAnnotation: NSObject,  MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    init(coor: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coor
        self.title = title
    }
}

