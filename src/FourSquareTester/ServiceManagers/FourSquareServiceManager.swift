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

class FourSquareServiceManager {
    static let shared = FourSquareServiceManager()
    
    private let CLIENT_ID:String = "ELS0QT1F4DR3E03WSJNJJMI21XAGSNRRFWQTESTLZDZGY40U"
    private let CLIENT_SECRET:String = "WG1JDU43TOG2O0VIWIQK0GHXBTPQ22UCGR0M0X2QMZ1DRTP4"
    private let API_VERSION:String = "20180323"
    
    private let API_SEARCH_URL:String = "https://api.foursquare.com/v2/venues/search"
    
    func getVenuesForCoordinate(_ coordinate:CLLocationCoordinate2D,
                                completionHandler: @escaping ([FourSquareVenue]) -> Void ) {
        var venuesFC = [FourSquareVenue]()
        
        let latitude = String(coordinate.latitude)
        let longitude = String(coordinate.longitude)
        let parameters: Parameters = ["ll": "\(latitude),\(longitude)",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "v": API_VERSION]
        
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
