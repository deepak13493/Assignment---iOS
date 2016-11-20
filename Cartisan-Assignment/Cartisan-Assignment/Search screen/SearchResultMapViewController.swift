//
//  SearchResultMapViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 20/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class SearchResultMapViewController: UIViewController {
    
    var searchResults: [SearchResult]?
    var serachResultDataManager = SearchResultDataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadData() {
        let dict = [("ll", "18.56,73.95"), ("v", "20161120")]
        serachResultDataManager.fetch(forData: dict) { [weak self](searchResults) in
            DispatchQueue.main.async {
                if let searchResults = searchResults {
                    self?.searchResults = searchResults
                    
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Please check your Network, If it is ok", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                        self?.loadData()
                        
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
       
    }
}

