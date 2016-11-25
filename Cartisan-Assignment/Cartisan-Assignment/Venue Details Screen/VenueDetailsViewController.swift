//
//  VenueDetailsViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 23/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class VenueDetailsViewController: BaseViewController {
    var venueID: String!
    var venueDeatils: VenueDetails?
    
    lazy var datFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }()
    
    @IBOutlet weak var venueDetailsView: VenueDeatilsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showActivityView()
        var venueDetailsDataManager = VenueDetailsDataManager()
        venueDetailsDataManager.fetch(forData: [("Venue_ID",venueID),("v",datFormatter.string(from: Date()))],
                                      data: { [weak self] (venueDetails) in
                                        DispatchQueue.main.async {
                                            self?.venueDeatils = venueDetails
                                            self?.venueDetailsView.configureView(withViewdetails: venueDetails!)
                                            self?.hideActivityView()
                                        }
                                        
            })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


