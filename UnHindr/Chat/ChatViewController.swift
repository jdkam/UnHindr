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
    
    //let db = Firestore.firestore()

    
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [Message] = []
    
    var thread = ""
    let myUserID = Services.userRef!
    let theirUserID = user_ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        //get the current users UID///
        //let myUserID = Auth.auth().currentUser!.uid
        
        print("CurrentUserID: \(myUserID)")
        print("user2DocumentID: \(user_ID)")
        
        thread = setOnetoOneChat(ID1: myUserID, ID2: theirUserID)
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        if(theirUserID != ""){
        loadMessages()
        }
        else
        {
            let title = "Oops"
            let message = "Please connect to a user first using the 'Connect' Feature to send and view messages."
            showAlert(title, message)
        }
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        Services.transitionHome(self)
    }
    
    func setOnetoOneChat(ID1:String, ID2:String) -> String
    {
        if(ID1 < ID2){
            return ID1+ID2;
        }
        else{
            return ID2+ID1;
        }
    }
    
    func showAlert(_ title:String, _ message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadMessages() {
        
        Services.db.collection("messages").document(thread).collection("ChatHistory")
            .order(by: "date")
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []

            if let e = error {
                print("Error retreiving firestore data \(e)")
            }
            else
            {
                if let snapshotDocuments = querySnapshot?.documents {
                    //loop through the array of document snapshots to tap into data of each of them
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    
    //When user presses send button, store the message to firestore
    @IBAction func sendPressed(_ sender: UIButton) {
        
        //if neither of these fields are not nil, then send data to firestore
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            Services.db.collection("messages").document(thread).collection("ChatHistory").addDocument(data: ["sender":messageSender, "body": messageBody, "date": Date().timeIntervalSince1970]) {
                (error) in
            //db.collection("messages").addDocument(data: ["sender":messageSender, "body": messageBody, "date": Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore. \(e)")
                }
                else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                    self.messageTextField.text = ""
                    }
                }
            }
        }
    }
    
}

//Protocol for managing the populating of the tableView
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = message.body

        
        //This is a message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            //print("Current User Message")
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: "BrandBlue")
            cell.label.textColor = UIColor.white
            
        }
        else //message from the sender
        {
            //print("Sender User message")
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: "lightGrey")
            cell.label.textColor = UIColor.black
        }
        
        
        return cell
    }
    
}



