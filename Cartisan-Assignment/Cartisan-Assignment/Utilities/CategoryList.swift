//
//  CategoryList.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 22/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

enum Category: Int {
    
    case Bakery,Building,Pizza,Bank,Workshop,Etc
    
    var title: String {
        switch self {
        case .Bakery: return "Bakery"
        case .Building: return "Building"
        case .Pizza: return "Pizza"
        case .Bank: return "Bank"
        case .Workshop: return "Workshop"
        case .Etc: return "Etc"
        }
    }
    
    var id : String? {
        switch self {
        case .Bakery:
            return "4bf58dd8d48988d16a941735"
        case .Building:
            return "4d954b06a243a5684965b473"
        case .Pizza:
            return "4bf58dd8d48988d1ca941735"
        case .Bank:
            return ""
        case .Workshop:
            return ""
        case .Etc:
            return nil
        }
    }
    
    static let count = 6
}
