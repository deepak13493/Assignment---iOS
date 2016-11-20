//
//  SearchResultDataParser.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 20/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

// parse json data and send it database helper
struct SearchResultDataParser {
    var issues: [SearchResult]?
    
    mutating func parse(_ forData: Data) -> [SearchResult]? {
        
        do {
            guard let parsedObjects = try JSONSerialization.jsonObject(with: forData, options: []) as? [String: AnyObject] else {
                return nil
            }
             let venues = parsedObjects["response"]?["venues"] as! [AnyObject]

        } catch let error as NSError {
            print(error.description)
        }
        
        return issues
    }
    
    private func fillModelClass(_ forObject: [String: AnyObject]) -> SearchResult {
        return SearchResult(title: forObject["title"] as? String, createdDate: forObject["created_at"] as? String, updatedDate: forObject["updated_at"] as? String, state: forObject["state"] as? String, details: forObject["body"] as? String, comments_url: forObject["comments_url"] as? String)
        
    }
    
}


