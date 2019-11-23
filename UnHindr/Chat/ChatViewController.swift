//
//  ChatViewController.swift
//  UnHindr
//
//  Created by Jordan Kam on 2019-11-22.
//  Copyright © 2019 Sigma. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [Message] = [
        Message(sender: "unittestacc@gmail.com", body: "YEE HAW"),
        Message(sender: "unittestacc1@gmail.com", body: "YA YEEEEEEEEEEEEEEEEEET"),
        Message(sender: "unittestacc@gmail.com", body: "FUK DIS")

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    

    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    
}

//Protocol for managing the populating of the tableView
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        
        cell.label.text = messages[indexPath.row].body
        return cell
    }
    
}


