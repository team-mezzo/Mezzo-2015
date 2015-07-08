//
//  Donor.swift
//  Mezzo-1.0
//
//  Created by Heejung Chung on 7/7/15.
//  Copyright (c) 2015 MezzoAwesomeness. All rights reserved.
//

import Foundation
import Parse

class Organization: PFObject, PFSubclassing {
    
    // MARK: Parse attributes
    
    @NSManaged var user: PFUser?
    @NSManaged var locatedAt: PFGeoPoint?
    @NSManaged var EIN: String
    @NSManaged var businessName: String
    
    // MARK: Methods
    
    // TODO: implement cancel method
    /**
        Cancels donation (only an organization can do this)
    
        :param: donation object to be cancelled
    */
    func cancelDonation(#donation: Donation) {
        // confirm that the donation is meant for this organization?
        // delete from Parse (or add a cancelled flag?)
        // notify donor of this donation
    }
    
    
    // MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "Organization"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
}