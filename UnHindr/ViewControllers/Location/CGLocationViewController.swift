//
//  CGLocationViewController.swift
//  UnHindr
//
//  Created by Sina Behrouz on 2019-11-30.
//  Copyright © 2019 Sigma. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class CGLocationViewController: UIViewController {
    let regionRadius: CLLocationDistance = 1000
    private var longitude = 0.0
    private var latitude  = 0.0
    var locationSnapshot: QuerySnapshot? = nil

    @IBOutlet weak var Caregivermap: MKMapView!
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()//Ask user for authorisation.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()//Initialize location for mapview
        Caregivermap.showsUserLocation = true
        /***grab the query of the user***/
        
        if(user_ID == ""){
            print("*****")
            print("userID is null" )
            Services.transitionHomeErrMsg(self, errTitle: "Please pick a User", errMsg: "")//Error message if no patient is selected
        }else{
            print("USER_ID DOES NOT EQUAL NULL")
            print(user_ID)
            //at this point we have the user ref
            getLocationDoc(user_ID) { (ret) in
                if !ret {
                    print("Error fetching patient location data")//Error message if patient has not pass any location data to firebase
                }else{
                    if (self.locationSnapshot!.count != 0){
                        self.latitude = self.locationSnapshot!.documents[0].get("latitude") as! Double
                        self.longitude = self.locationSnapshot!.documents[0].get("longitude") as! Double//get patient coordinate
                        self.Caregivermap.delegate = self
                        let patient = Patient(title: "Patient",
                                              locationName: "Patient",
                                              discipline: "none",
                                              coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
                        self.Caregivermap.addAnnotation(patient)//add pin on patient location in map.
                    }
                    else{
                        Services.showAlert("Error", "There is no recorded patient data", vc: self)
                    }
                }
            }
            
        }
        /**********/
//        print("*****")
//        print(self.latitude)
//        print(self.longitude)
//        print("*****")
//        Caregivermap.delegate = self
//        let patient = Patient(title: "Patient",
//                              locationName: "Patient",
//                              discipline: "none",
//                              coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
//        Caregivermap.addAnnotation(patient)
        // Do any additional setup after loading the view.
    }//viewDidLoad
    
    @IBAction func centerAtPatient(_ sender: UIButton) {
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        Caregivermap.setRegion(coordinateRegion, animated: true)
        //Recenter to patient's location
    }
    
    
    
    // Input:
    //      1. UserRef: unique user id
    //      2. CompletionHandler
    // Output:
    //      1. grabs the document id for user's location
    func getLocationDoc(_ userRef: String, completionHandler: @escaping (Bool) -> Void) {
        Services.fullUserRef.document(userRef).collection(Services.locationName).getDocuments { (querySnapshot, err) in
            if (err != nil){
                //error
            }
            else {
                self.locationSnapshot = querySnapshot
                completionHandler(true)
            }
        }
    }
    
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        Services.transitionHome(self)
    }
    
    
}

extension CGLocationViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {//marker configeration
        guard let annotation = annotation as? Patient else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {//transit for app to map app to start navigation
        let location = view.annotation as! Patient
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }

}
