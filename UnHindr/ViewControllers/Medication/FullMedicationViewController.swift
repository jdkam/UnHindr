/*
File: [FullMedicationViewController.swift]
Creators: [Allan]
Date created: [23/11/2019]
Date updated: [23/11/2019]
Updater name: []
File description: [Controls the full medication list]
*/

import UIKit
import FirebaseFirestore

/// Class for managing the full medication view controller
class FullMedicationViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var medTableView: UITableView!
    
    let medicationPlanRef = Services.fullUserRef.document(Services.userRef!).collection(Services.medPlanName)
    
    var medList: QuerySnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        medTableView.dataSource = self
        
        getAllMedicationPlans(Services.userRef!) { (success) in
            if (success) {
                self.medTableView.reloadData()
            }
        }
    }
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medList?.count ?? 0
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Determine the identifier for each cell (set in storyboard)
        let cellIdentifier = "MedicationTableViewCell"
        // Attempt to request a reusable cell from the table view
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicationTableViewCell else {
            fatalError("The dequeued cell is not an instance of MedicationTableViewCell")
        }
        
        let med = self.medList?.documents[indexPath.row]
        // Configure cell
        cell.medicationNameLabel.text = med?.get("Medication") as? String
        cell.dosageLabel.text = "Dosage: \(med?.get("Dosage") as! Int)"
        cell.quantityLabel.text = "Quantity: \(med?.get("Quantity") as! Int)"
//        cell.reminderTimeLabel
        //cell.dayOfWeekLabel
        
        return cell
    }
    

}


//extension FullMedicationViewController : UITableViewDataSource {
//
//}
