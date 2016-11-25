//
//  VenueDetailsDataParser.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 24/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

// parse json data and send it database helper
struct VenueDetailsDataParser {
    var venueDetails: VenueDetails?
    
    mutating func parse(_ forData: Data) -> VenueDetails? {
        
        do {
            guard let parsedObjects = try JSONSerialization.jsonObject(with: forData, options: []) as? [String: AnyObject] else {
                return nil
            }
            let venue = parsedObjects["response"]?["venue"] as! [String: AnyObject]
           return fillModelClass(venue)
            
        } catch let error as NSError {
            print(error.description)
        }
        
        return venueDetails
    }
    
    private func fillModelClass(_ forObject: [String: AnyObject]) -> VenueDetails {
        
        let location = forObject["location"] as? [String: AnyObject]
        let contact = forObject["contact"] as? [String: AnyObject]
        let category = forObject["categories"] as? [AnyObject]
        let categoryName = (category?.first as? [String: AnyObject])?["name"]
        let categoryicon = ((category?.first as? [String: AnyObject])?["icon"] as? [String: AnyObject])
        var categoryiconURL = ""
        if let categoryicon = categoryicon {
            for (_,value) in categoryicon {
                categoryiconURL += value as! String
            }
        }
        let stat = forObject["stats"] as! [String: Int]
        return VenueDetails(name: forObject["name"] as? String,
                            contactNumber: contact?["phone"] as? String,
                            address:  location?["address"] as? String,
                            categoryName: categoryName as? String,
                            categoryImageURL: categoryiconURL ,
                            categoryStats:stat)
        
        
    }
    
}


