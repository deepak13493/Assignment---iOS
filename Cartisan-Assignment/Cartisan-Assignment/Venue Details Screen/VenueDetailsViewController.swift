//
//  VenueDetailsViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 23/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class VenueDetailsViewController: UIViewController {
    var venueID: String!
    var venueDeatils: [VenueDetails]?
    
    lazy var datFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var venueDetailsDataManager = VenueDetailsDataManager()
        venueDetailsDataManager.fetch(forData: [("Venue_ID",venueID),("v",datFormatter.string(from: Date()))],
                                      data: { [weak self] (venueDetails) in
        self?.venueDeatils = venueDetails

    })
        
        print("venueID\(venueID)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
