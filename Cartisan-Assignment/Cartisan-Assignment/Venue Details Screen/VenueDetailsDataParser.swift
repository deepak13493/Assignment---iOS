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
    var issues: [SearchResult]?
    
    mutating func parse(_ forData: Data) -> [SearchResult]? {
        
        do {
            guard let parsedObjects = try JSONSerialization.jsonObject(with: forData, options: []) as? [String: AnyObject] else {
                return nil
            }
            let venues = parsedObjects["response"]?["venues"] as! [AnyObject]
            return venues.map( {fillModelClass($0 as? [String: AnyObject] ?? [String: AnyObject]() ) })
            
        } catch let error as NSError {
            print(error.description)
        }
        
        return issues
    }
    
    private func fillModelClass(_ forObject: [String: AnyObject]) -> SearchResult {
        
        let location = forObject["location"] as? [String: AnyObject]
        return SearchResult(id: forObject["id"] as? String,
                            name: forObject["name"] as? String,
                            lat: location?["lat"] as? Double,
                            lng: location?["lng"] as? Double)
        
    }
    
}
