/*
 File: [MessageCell.swift]
 Creators: [Jordan]
 Date created: [24/11/2019]
 Date updated: [1/12/2019]
 Updater name: [Jordan]
 File description: [A class inheriting the TableViewCell that configures a custom tableViewCell. Used to Create a custom chat bubble for our messages to appear]
 */

import UIKit

//Used in conjuction with our MessageCell.xib file to have a custom appearance for our chat bubbles
class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height/5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
