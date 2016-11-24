//
//  VenueDetailsAPIHandler.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 24/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation
import UIKit

protocol VenueDetailsAPIHandlerDelegate {
    func venueDetailsData(_ data: [VenueDetails]?)
}

struct VenueDetailsAPIHandler: APIManagerDelegate {
    
    var apiManager = APIManager()
    var delegate: VenueDetailsAPIHandlerDelegate?
    
    mutating func fetchVenueDetailsData(_ formUrl: String?)  {
        guard let formUrl = formUrl else {
            return
        }
        apiManager.delegate = self
        apiManager.request(formUrl)
        
    }
    //MARK:- APIManagerDelegate delegate method
    func response(_ data: Data?, error: NSError?) {
        
        guard let data = data else {
            delegate?.venueDetailsData(nil)
            return
        }
        
        // parse logic
        
//        var searchResultDataParser = SearchResultDataParser()
//        let issueContainerData = searchResultDataParser.parse(data)
//        delegate?.searchedData(issueContainerData)
    }
}
