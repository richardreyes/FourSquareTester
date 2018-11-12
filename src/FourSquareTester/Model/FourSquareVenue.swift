//
//  FourSquareVenue.swift
//  FourSquareTester
//
//  Created by Richard on 11/11/2018.
//  Copyright © 2018 Richard Reyes. All rights reserved.
//

import Foundation

struct FourSquareVenue {
    // structure definition goes here
    var name = ""
    var formattedAddress = ""
    var distanceInMtrs:Int = 0
    
    init(_ place : [String : Any]) {
        self.name = ""
        self.formattedAddress = ""
        self.distanceInMtrs = 0
        
        if let placeName = place["name"] as? String {
            self.name = placeName
        }
        
        if let location = place["location"] as? [String: Any] {
            if let distanceInMeters = location["distance"] as? Int {
                self.distanceInMtrs = distanceInMeters
            }
            
            if let formattedAddressArray = location["formattedAddress"] as? [String] {
                let formattedAddress = formattedAddressArray.joined(separator: ", ")
                self.formattedAddress = formattedAddress
            }
        }

        
    }
    
}
