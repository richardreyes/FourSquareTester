//
//  FourSquareServiceManager.swift
//  FourSquareTester
//
//  Created by Richard on 07/22/2018.
//  Copyright © 2018 Richard Reyes. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON
import SwiftyConfiguration

class FourSquareServiceManager {
    static let shared = FourSquareServiceManager()
    
    private let API_SEARCH_URL:String = "https://api.foursquare.com/v2/venues/search"
    
    lazy var config: Configuration? = {
        let plistPath = Bundle.main.path(forResource: "Configs", ofType: "plist")!
        if let config = Configuration(plistPath: plistPath) {
            return config
        }
        return nil
    }()
    
    func getVenuesForCoordinate(_ coordinate:CLLocationCoordinate2D,
                                completionHandler: @escaping ([FourSquareVenue]) -> Void ) {
        
        let fourSquareClientSecret = config?.get(.fourSquareClientSecret) ?? ""
        let fourSquareAPIVersion   = config?.get(.fourSquareAPIVersion) ?? ""
        let fourSquareClientID     = config?.get(.fourSquareClientID) ?? ""

        var venuesFC = [FourSquareVenue]()
        
        let latitude = String(coordinate.latitude)
        let longitude = String(coordinate.longitude)
        let parameters: Parameters = ["ll": "\(latitude),\(longitude)",
            "client_id": fourSquareClientID,
            "client_secret": fourSquareClientSecret,
            "v": fourSquareAPIVersion]
        
        Alamofire.request(API_SEARCH_URL,
                          method: .get,
                          parameters: parameters).responseJSON { response in
                if let alReponseValue = response.result.value {
                    let sjr = JSON(alReponseValue)
                    if let venues = sjr["response"]["venues"].arrayObject {
                        //Now you got your value
                        for venue in venues {
                            if let place = venue as? [String: Any] {
                                venuesFC.append(FourSquareVenue(place))
                            }
                        }
                        venuesFC = venuesFC.sorted(by: { $0.distanceInMtrs < $1.distanceInMtrs })
                    }
                }
                completionHandler(venuesFC)
        }
    }
    
    
}
