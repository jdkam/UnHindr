/*
File: [MedicationTableViewCell.swift]
Creators: [Allan]
Date created: [23/11/2019]
Date updated: [23/11/2019]
Updater name: []
File description: [Controls what is displayed for each table view cell]
*/

import UIKit

// Class for managing each instance of table view cell
class MedicationTableViewCell: UITableViewCell {

    // Properties
    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        dayOfWeekLabel.lineBreakMode = .byWordWrapping
//        dayOfWeekLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
