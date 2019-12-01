//
//  CaregiverPatientsViewController.swift
//  UnHindr
//
//  Created by Johnston Yang on 11/23/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit
import FirebaseFirestore

var caregiverPatients: [String] = []
//var myIndex = 0
//var selectedPatient: String = ""
var userID: String = ""

class CaregiverPatientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    let caregiverRef = Services.db.collection("users").document(Services.userRef!).collection("Connections")

    var connectionSnapshot: QuerySnapshot?

    @IBOutlet weak var listOfPatients: UITableView!

    override func viewDidLoad() {

        super.viewDidLoad()
        listOfPatients.dataSource = self
        listOfPatients.delegate = self
        getPatientData(Services.userRef!) { (success) in
            if (success){
                self.listOfPatients.reloadData()
            }
        }
    }

    func getPatientData(_ userRef: String, completionHandler: @escaping (Bool) -> Void){
        Services.fullUserRef.document(userRef).collection(Services.connectionName)
            .getDocuments { (querySnapshot, err) in
                if err != nil
                {
                    print("Error getting caregiver data")
                    completionHandler(false)
                }
                else
                {
                    self.connectionSnapshot = querySnapshot
                    completionHandler(true)
                }

        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return caregiverPatients.count
        return connectionSnapshot?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaregiverPatients", for: indexPath)

        // Configure the cell...
//        cell.textLabel!.text = caregiverPatients[indexPath.row]
        cell.textLabel!.text = connectionSnapshot?.documents[indexPath.row].get("email") as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPatient = connectionSnapshot?.documents[indexPath.row].get("email") as! String
        getRefFromEmail(selectedPatient) { (ref) in
            if ref != " " {
                userID = ref
            }
        }
    }

    func getRefFromEmail(_ connectedEmail: String, completionHandler: @escaping (String) -> Void) {
        Services.fullUserRef
            .whereField("email", isEqualTo: connectedEmail)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    completionHandler("")
                }
                else {
                    completionHandler((querySnapshot?.documents[0].documentID)!)
                }
            }
    }

}
