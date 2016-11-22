//
//  SearchResultMapAnnotation.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 23/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit
import MapKit

class SearchResultMapAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var searchedResultID : String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, searchedResultID: String?) {
        self.coordinate = coordinate
        self.title = title
        self.searchedResultID = searchedResultID
    }
}
