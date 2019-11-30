//
//  LocationViewController.swift
//  UnHindr
//
//  Created by Wei Liu on 11/23/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager:CLLocationManager = CLLocationManager()//Declaration of varible storing user location.

        override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()//Ask user for authorisation.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true

       
    }
    
    let regionRadius: CLLocationDistance = 1000
    @IBAction func Center(_ sender: Any) {
        let coordinateRegion = MKCoordinateRegion(center: locationManager.location!.coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        //Recenter to user's location
    }
    
  

    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
