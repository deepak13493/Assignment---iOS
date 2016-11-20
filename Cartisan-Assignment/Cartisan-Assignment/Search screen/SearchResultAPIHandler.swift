//
//  SearchResultAPIHandler.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 20/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation
import UIKit

protocol SearchResultAPIHandlerDelegate {
    func searchedData(_ data: [SearchResult]?)
}

struct SearchResultAPIHandler: APIManagerDelegate {
    
    var apiManager = APIManager()
    var delegate: SearchResultAPIHandlerDelegate?
    
    mutating func fetchSearcheData(_ formUrl: String?)  {
        guard let formUrl = formUrl else {
            return
        }
        apiManager.delegate = self
        apiManager.request(formUrl)
        
    }
    //MARK:- APIManagerDelegate delegate method
    func response(_ data: Data?, error: NSError?) {
        
        guard let data = data else {
            delegate?.searchedData(nil)
            return
        }
        var searchResultDataParser = SearchResultDataParser()
        let issueContainerData = searchResultDataParser.parse(data)
        delegate?.searchedData(issueContainerData)
    }
}
