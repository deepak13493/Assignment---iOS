//
//  VenueDetailsDataManager.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 24/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

//replace it with plist
private let baseURL = "https://api.foursquare.com/v2/venues/"

struct VenueDetailsDataManager: VenueDetailsAPIHandlerDelegate {
    
    private var venueDetailsData: (([VenueDetails]?) -> Void)?
    private var parameters  = [("client_id", client_id),("client_secret", client_secret)]
    
    mutating func fetch(forData dataDictionary: [(String,String)], data: @escaping (([VenueDetails]?) -> Void) )  {
        
        //let allParameters = parameters + dataDictionary
        self.venueDetailsData = data
        var venueDetailsAPIHandler = VenueDetailsAPIHandler()
        venueDetailsAPIHandler.delegate = self
        
        let credientialURL = parameters.reduce("") { (appendURL: String,  parameter) -> String in
            var completeURL = appendURL
            completeURL += parameter.0 + "=" + parameter.1 + "&"
            return completeURL
        }
        
        let url = baseURL + dataDictionary.first!.1  + "?" + credientialURL
        
        var completeURL = url + dataDictionary.last!.0 + "=" + dataDictionary.last!.1
        
        completeURL = String(completeURL.characters.dropLast())
        venueDetailsAPIHandler.fetchVenueDetailsData(completeURL)
        
    }
    
    //MARK:- SearchResultAPIHandlerDelegate method
    func venueDetailsData(_ data: [VenueDetails]?) {
        
        if let data = data {
            venueDetailsData?(data)
        } else {
            venueDetailsData?(nil)
            return
        }
    }
    
}
