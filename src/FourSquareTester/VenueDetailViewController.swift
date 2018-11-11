//
//  VenueDetailViewController.swift
//  FourSquareTester
//
//  Created by Richard on 07/22/2018.
//  Copyright © 2018 Richard Reyes. All rights reserved.
//

import UIKit

class VenueDetailViewController: UIViewController {

    var selectedVenue:FourSquareVenue?
    
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        venueName.text = selectedVenue?.name
        venueAddress.text = selectedVenue?.formattedAddress
    }

}
