/*
File: [LocationViewController.swift]
Creators: [Sina]
Date created: [20/11/2019]
Date updated: [22/11/2019]
Updater name: [Sina]
Class Description: [Displays and updates physical location]
*/


import UIKit
import MapKit
import CoreLocation
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class LocationViewController: UIViewController {
    let regionRadius: CLLocationDistance = 1000
    var locationSnapshot: QuerySnapshot?
    
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager:CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ask user for authorisation.
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        getLocationData(Services.userRef!) { (ret) in
            if !ret {
                print("Failed to load location data")
            }
        }
       
    }
    
    // Input:
    //      1. sender
    // Output:
    //      1. Centers the User's location on map
    @IBAction func Center(_ sender: Any) {
        let coordinateRegion = MKCoordinateRegion(center: locationManager.location!.coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        //Recenter to user's location
    }
    
    
    // Input:
    //      1. UserRef: unique user id
    //      2. CompletionHandler
    // Output:
    //      1. grabs the document id for user's location
    func getLocationData(_ userRef: String, completionHandler: @escaping (Bool) -> Void) {
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
    
    
    // Input:
    //      1. sender
    // Output:
    //      1. Update the location of the patient in Firebase
    @IBAction func UpdateCoordinatesPressed(_ sender: Any) {
        let user_lat = locationManager.location!.coordinate.latitude
        let user_lng = locationManager.location!.coordinate.longitude
        var fields = [String:Double]()
        fields.updateValue(user_lat, forKey: "latitude")
        fields.updateValue(user_lat, forKey: "longitude")
        
        let docID = locationSnapshot?.documents[0].documentID
        let ref = Services.fullUserRef.document(Services.userRef!).collection("Location").document(docID!)

        ref.updateData([
            "latitude": user_lat,
            "longitude": user_lng
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

}
