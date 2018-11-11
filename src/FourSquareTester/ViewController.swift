//
//  ViewController.swift
//  FourSquareTester
//
//  Created by Richard on 07/22/2018.
//  Copyright © 2018 Richard Reyes. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var venues = [FourSquareVenue]()
    var selectedVenue:FourSquareVenue?
    
    lazy var locationManager: CLLocationManager = {
        let m = CLLocationManager()
        return m
    }() //locationManager
    
    var currentLocation:CLLocation? = nil // current location
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Venues"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            //locationManager.startMonitoringSignificantLocationChanges()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        title = ""
        if let dvc = segue.destination as? VenueDetailViewController {
            dvc.selectedVenue = self.selectedVenue
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if case .authorizedWhenInUse = status {
            manager.requestWhenInUseAuthorization()
        } else {
            //TODO: we didn't get access, handle this
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //TODO: now you have access to the location. do your work
        
        if let location = manager.location {
            self.currentLocation = location
            manager.stopUpdatingLocation()
            
            FourSquareServiceManager.shared.getVenuesForCoordinate(location.coordinate) { (fsVenues) in
                
                DispatchQueue.main.async { [unowned self] in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.alpha = 0.0
                    })
                }
                
                if fsVenues.count <= 0 {
                    self.statusLabel.text = "No venues retrieved."
                    return
                }
                
                DispatchQueue.main.async { [unowned self] in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.venues = fsVenues
                        self.tableView.reloadData()
                        self.tableView.alpha = 1.0
                    })
                }
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("---------------------------- error")
        print(error.localizedDescription)
        self.statusLabel.text = error.localizedDescription
        //TODO: handle the error
        //self.locationTF.text = "There was an error getting your location. Please enter location."
        
    }
}

//
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let venue = self.venues[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FSVRightDetailCell",
                                                    for: indexPath)
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = "\(venue.distanceInMtrs) meters" 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        self.selectedVenue = self.venues[row]
        
        self.performSegue(withIdentifier: "Show Detail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

