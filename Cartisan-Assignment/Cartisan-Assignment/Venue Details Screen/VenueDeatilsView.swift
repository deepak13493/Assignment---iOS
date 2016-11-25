//
//  VenueDeatilsView.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 26/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class VenueDeatilsView: UIView {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var cateoryStats: UILabel!

    func configureView(withViewdetails venueDetail: VenueDetails) {
      
        name.attributedText = attribuedText("Venue Name: ", normalText: (venueDetail.name ?? ""))
        contact.attributedText = attribuedText("Contact No: ", normalText: (venueDetail.contactNumber ?? ""))

        address.attributedText = attribuedText("Address: ", normalText: (venueDetail.address ?? ""))
        //we are not getting image access denied error that's why we are not showing image
        //need to check it

        categoryName.attributedText = attribuedText("Category: ", normalText:(venueDetail.categoryName ?? ""))

        name.attributedText = attribuedText("Venue Name: ", normalText: (venueDetail.name ?? ""))

        var statics = ""
        for (key,value) in (venueDetail.categoryStats ?? [String: Int]()) {
            statics += key + ": "+String(value) + "\n"
        }
        cateoryStats.attributedText = attribuedText("Stats: ", normalText: statics)
        self.setNeedsLayout()
    }
    
}

private func attribuedText(_ boldtext: String, normalText: String) -> NSMutableAttributedString {
    
    let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
    let boldString = NSMutableAttributedString(string:boldtext, attributes:attrs)
    let attributedString = NSMutableAttributedString(string:normalText)

    boldString.append(attributedString)
    
    return boldString

}
