//
//  LocationController.swift
//  RAT
//
//  Created by Анастасия Шахлан on 17.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!

    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
        longitude.text! = String(Double((locationManager.location?.coordinate.longitude)!))
        latitude.text! = String(Double((locationManager.location?.coordinate.latitude)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //gab
    }
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //agfb
    }

}
