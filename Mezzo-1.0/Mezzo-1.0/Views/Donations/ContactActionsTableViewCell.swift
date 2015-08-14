//
//  ContactActionsTableViewCell.swift
//  Mezzo-1.0
//
//  Created by Heejung Chung on 8/7/15.
//  Copyright (c) 2015 MezzoAwesomeness. All rights reserved.
//

import UIKit
import Mixpanel
import Parse

protocol ContactCellDelegate: class {
    func sendEmail(donation: Donation)
}

class ContactActionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    
    weak var delegate: ContactCellDelegate!
    
    weak var donation: Donation! {
        didSet {
            UIHelper.colorButtons([callButton, emailButton, routeButton], color: UIHelper.Colors.completedGray, bold: false)
        }
    }
    
    @IBAction func callButtonPressed(sender: UIButton) {
        let mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("existing donation", properties: ["action" : "dial phone number", "donation state" : donation.donationState.rawValue])
        
        var oldPhone = ""
        if let orgUser = (PFUser.currentUser() as? User)?.organization {
            oldPhone = donation.fromDonor!.phoneNumber
        } else if let donorUser = (PFUser.currentUser() as? User)?.donor {
            oldPhone = donation.toOrganization!.phoneNumber
        }
        
        var newPhone = ""
        
        for index in oldPhone.startIndex..<oldPhone.endIndex{
            let charAtIndex = oldPhone[index]
            
            switch charAtIndex {
            case "0","1","2","3","4","5","6","7","8","9":
                newPhone = newPhone + String(charAtIndex)
            default:
                break
            }
        }
        
        if let url = NSURL(string: "tel://\(newPhone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    @IBAction func emailButtonPressed(sender: UIButton) {
        delegate.sendEmail(donation)
        let mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("existing donation", properties: ["action" : "email", "donation state" : donation.donationState.rawValue])
    }
    
    @IBAction func routeButtonPressed(sender: UIButton) {
        let mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("existing donation", properties: ["action" : "see location", "donation state" : donation.donationState.rawValue])
        
        let location = donation.location()
        
        if let lat = location.latitude, long = location.longitude {
            if UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!) {
                let searchable = donation.locationString().stringByReplacingOccurrencesOfString(" ", withString: "+")
                UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?q=\(searchable)&center=\(lat),\(long)&zoom=14")!)
            } else {
                // go to apple maps
            }
        }
    }
    

}
