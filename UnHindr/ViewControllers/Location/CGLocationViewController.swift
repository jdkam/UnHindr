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
    var locationSnapshot: QuerySnapshot? // locationSnapshot?.documents[0].documentID

    @IBOutlet weak var Caregivermap: MKMapView!
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()//Ask user for authorisation.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        Caregivermap.showsUserLocation = true
        /***grab the query of the user***/
        
        if(user_ID == ""){
            print("*****")
            print("userID is null" )
            Services.transitionHomeErrMsg(self, errTitle: "PleasePick a User", errMsg: "")
        }else{
            print("USER_ID DOES NOT EQUAL NULL")
            print(user_ID)
            //at this point we have the user ref
            getLocationDoc(user_ID) { (ret) in
                if !ret {
                    print("Failed to load location data")
                }else{
                    let docID = self.locationSnapshot?.documents[0].documentID
                    let ref = Services.db.collection("users").document(user_ID).collection("Location").document(docID!)
                    
                    for document in self.locationSnapshot!.documents{
                        self.latitude = document.get("latitude") as! Double
                        self.longitude = document.get("longitude") as! Double
                        print("*****")
                        print(self.latitude)
                        print(self.longitude)
                        print("*****")
                    }
                }
            }
        }
        /**********/
        
        Caregivermap.delegate = self
        let patient = Patient(title: "Patient",
                              locationName: "Patient",
                              discipline: "none",
                              coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        Caregivermap.addAnnotation(patient)
        // Do any additional setup after loading the view.
    }//viewDidLoad
    
    @IBAction func centerAtPatient(_ sender: UIButton) {
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        Caregivermap.setRegion(coordinateRegion, animated: true)
        //Recenter to user's location
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
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Patient else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Patient
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }

}
