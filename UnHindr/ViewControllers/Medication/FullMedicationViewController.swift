/*
File: [FullMedicationViewController.swift]
Creators: [Allan]
Date created: [11/23/2019]
Date updated: [11/30/2019]
Updater name: [Allan]
File description: [Controls the full medication list]
*/

import UIKit
import FirebaseFirestore

/// Class for managing the full medication view controller
class FullMedicationViewController: UIViewController {
    
    // Reference to the UITableView under full medication view controller
    @IBOutlet weak var medTableView: UITableView!
    
    // Static reference to the current user's medication plan
    let (medicationPlanRef, _) = Services.checkUserIDMed()
//    let medicationPlanRef = Services.fullUserRef.document(Services.userRef!).collection(Services.medPlanName)
    
    // Create the batch writing
    let batch = Services.db.batch()
    
    // Snapshot of the current user's medication plan
    var medList: QuerySnapshot?
    
    // MARK: - Controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        medTableView.dataSource = self
        medTableView.delegate = self
        
        if (user_ID == ""){
            getAllMedicationPlans(Services.userRef!) { (success) in
                if (success) {
                    self.medTableView.reloadData()
                }
            }
        }
        else {
            getAllMedicationPlans(user_ID) { (success) in
                if (success) {
                    self.medTableView.reloadData()
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Update remote firebase with new medication list
        batch.commit() { err in
            if err != nil {
                print("Error writing batch")
            }
        }
    }
    
    // MARK: - Helper function to retrieve data from firestore
    // Function to retrieve the full medication plan for a given user
    // Input:
    //      1. User reference
    // Output:
    //      1. True -> medication plan is fetched and stored into the query snapshot
    //      2. False -> unable to fetch plan
    func getAllMedicationPlans(_ userRef: String, completionHandler: @escaping (Bool) -> Void){
        Services.fullUserRef.document(userRef).collection(Services.medPlanName)
            .order(by: "Medication")
            .getDocuments { (querySnapshot, err) in
            if err != nil {
                // Error fetching snapshot of plans
                completionHandler(false)
            }
            else {
                self.medList = querySnapshot
                completionHandler(true)
            }
        }
    }
    
    // Function to generate a Medication entry
    // Input:
    //      1. Query snapshot of medication
    // Output:
    //      1. A Medication class object
    private func generatePlan(medPlan: QueryDocumentSnapshot) -> Medication{
        let medName = medPlan.get("Medication") as! String
        let dosage = medPlan.get("Dosage") as! Int
        let quantity = medPlan.get("Quantity") as! Int
        
        // Parse the reminder time
        let timeString = medPlan.get("ReminderTime") as? String
        var arr = timeString!.components(separatedBy: [":", " "])
        if (arr.count == 2){
            if Int(arr[0])! > 12 {
                arr[0] = String(Int(arr[0])! - 12)
                arr.append("PM")
            }
            else {
                arr.append("AM")
            }
        }
        else {
            print("Error parsing reminder time from firestore")
        }
        let timeStr = arr[0] + ":" + arr[1] + " " + arr[2]
        
        // Parse the days of the week
        let dayArr = medPlan.get("Day") as! [String]
        print(dayArr.count)
        //cell.dayOfWeekLabel
        
        return Medication (medName: medName, dosage: dosage, quantity: quantity, reminderTime: timeStr, days: dayArr)
//        var dict: [String: String] = [:]
//        dict["medName"] = medPlan.get("Medication") as? String
//        dict["dosage"]
    }
    

}

// Extension to control the swiping and showing of data on the UIViewTable
extension FullMedicationViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table View functions
    // Returns the number of sections of the UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Output:
    //      1. The number of medication for the current day
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medList?.count ?? 0
    }
    
    // Populates each instance of the table view with its corresponding medication plan
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Determine the identifier for each cell (set in storyboard)
        let cellIdentifier = "MedicationTableViewCell"
        // Attempt to request a reusable cell from the table view
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicationTableViewCell else {
            fatalError("The dequeued cell is not an instance of MedicationTableViewCell")
        }
        
        let med = self.medList?.documents[indexPath.row]
        
        let medPlan = generatePlan(medPlan: med!)
        // Configure cell
        cell.medicationNameLabel.text = medPlan.medName
        cell.dosageLabel.text = "Dosage: \(medPlan.dosage)"
        cell.quantityLabel.text = "Quantity: \(medPlan.quantity)"
        // Parse the reminder time
        cell.reminderTimeLabel.text = medPlan.ReminderTime
        var dayOfWeek: String = ""
        for i in 0..<medPlan.Day.count{
            // Grab additional characters for days that start with T or S
            let prefix = String(medPlan.Day[i].prefix(1))
            if (prefix == "T" || prefix == "S") {
                dayOfWeek.append(String(medPlan.Day[i].prefix(2)))
            }
            else {
                dayOfWeek.append(String(medPlan.Day[i].prefix(1)))
            }
            if (i != medPlan.Day.count - 1) {
                dayOfWeek.append(",")
            }
        }
        cell.dayOfWeekLabel.text = dayOfWeek
        
        return cell
    }

    // Enables swiping gesture for editting and deleting medication from the full medication list
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            let docRef = self.medicationPlanRef.document(self.medList!.documents[indexPath.row].documentID)
            let manager = NotificationManager()
            let medName = self.medList!.documents[indexPath.row].get("Medication") as! String
            let daysArr = self.medList!.documents[indexPath.row].get("Day") as! [String]
            for day in daysArr {
                manager.unscheduleNotifications(id: "\(medName) - \(day)")
            }
            self.batch.deleteDocument(docRef)
            print(self.batch)
            success(true)
        })
        
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            let storyboard = UIStoryboard.init(name: "AddMed", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "AddMedicationViewController") as! AddMedicationViewController
            guard let snapshot = self.medList?.documents[indexPath.row] else {
                return
            }
            destinationVC.snapshot = snapshot
            self.present(destinationVC, animated:true, completion: nil)
            success(true)
        })

        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }

}
