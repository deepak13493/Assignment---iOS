//
//  CategoryList.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 22/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

enum Category: String {
    case Bakery,Building
    
    var id : String {
        switch self {
        case .Bakery:
            return "4bf58dd8d48988d16a941735"
        case .Building:
            return "4d954b06a243a5684965b473"
        }
    }
}
