/*
File: [MedicationTableViewCell.swift]
Creators: [Allan]
Date created: [23/11/2019]
Date updated: [30/11/2019]
Updater name: [Allan]
File description: [Defines the template for each cell under full medication list]
*/

import UIKit

// Class for managing each instance of table view cell under full medication list
class MedicationTableViewCell: UITableViewCell {

    // Properties
    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    
    // MARK: - UITableViewCell lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    // Default function
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
