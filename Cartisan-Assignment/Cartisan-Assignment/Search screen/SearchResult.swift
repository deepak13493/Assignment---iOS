//
//  SearchResult.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 20/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

//used to store issue api data as container which will use for store in database
struct SearchResult {
    let title: String?
    let createdDate: String?
    let updatedDate: String?
    let state: String?
    let details: String?
    let comments_url: String?
}
