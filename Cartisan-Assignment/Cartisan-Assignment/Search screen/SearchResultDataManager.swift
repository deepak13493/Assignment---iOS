//
//  SearchResultDataManager.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 20/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

//replace it with plist
private let baseURL = "https://api.foursquare.com/v2/venues/search?"
private let client_id = "VV1XZLSNNXFNKJNK2W3TVPPANWG23LBD44Q5XS02ABUHWW0N"
private let client_secret = "KUIECTYOOFW320MTT24JVJ0XFXK13OT5KRG4OYQCA02XI1KW"


struct SearchResultDataManager: SearchResultAPIHandlerDelegate {
    
    private var searchedData: (([SearchResult]?) -> Void)?
    private var parameters  = [("client_id", client_id),("client_secret", client_secret)]

    mutating func fetch(forData dataDictionary: [(String,String)], data: @escaping (([SearchResult]?) -> Void) )  {
      
       let allParameters = parameters + dataDictionary
        self.searchedData = data
        var searchResultAPIHandler = SearchResultAPIHandler()
        searchResultAPIHandler.delegate = self
        
        var completeURL =  allParameters.reduce(baseURL) { (appendURL: String,  parameter) -> String in
            var completeURL = appendURL
            completeURL +=   parameter.0 + "=" + parameter.1 + "&"
            return completeURL
        }
        completeURL = String(completeURL.characters.dropLast())
        searchResultAPIHandler.fetchSearcheData(completeURL)
        
    }
    
    //MARK:- SearchResultAPIHandlerDelegate method
     func searchedData(_ data: [SearchResult]?) {
        
        if let data = data {
            searchedData?(data)
        } else {
            searchedData?(nil)
            return
        }
    }
   
}

extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
