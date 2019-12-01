/*
 File: [ChatViewController.swift]
 Creators: [Jordan]
 Date created: [24/11/2019]
 Date updated: [1/12/2019]
 Updater name: [Jordan]
 File description: [Controls the Chat view, by sending and retrieving message data from firestore and displaying the messages in the tableView]
 */

import Foundation
import UIKit
import Firebase


class ChatViewController: UIViewController {
    
    //let db = Firestore.firestore()

    
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [Message] = []
    
    //create variables for storing unique IDs
    //thread is the concatenated strings of current user ID + connected user ID
    var thread = ""
    let myUserID = Services.userRef!
    let theirUserID = user_ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        //concatenate the two userIDs
        thread = setOnetoOneChat(ID1: myUserID, ID2: theirUserID)
        
        //init the custom message cell that we will use to display message bubbles
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        //if there is no user connected, then dont load chat history
        if(theirUserID != ""){
        loadMessages()
        }
        else //display alert that you are not connected
        {
            let title = "Oops"
            let message = "Please connect to a user first using the 'Connect' Feature to send and view messages."
            showAlert(title, message)
        }
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        Services.transitionHome(self)
    }
    
    
    //MARK: - setOnetoOneChat
    //Input: Two user IDs
    //Output: Returns the concatenated string of the two user IDS
    func setOnetoOneChat(ID1:String, ID2:String) -> String
    {
        if(ID1 < ID2){
            return ID1+ID2;
        }
        else{
            return ID2+ID1;
        }
    }
    
    //MARK: - showAlert
    //input: title and body of alert message
    //output: Presents an alert to the screen
    func showAlert(_ title:String, _ message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - loadMessages (Data Retrieval)
    //input: None
    //output: Updates the messages array with new messages from firestore
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
    
    
    //MARK: - sendPressed (Data Storage)
    //input: on the send button press
    //output: stores the message in the textField to firestore
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

//MARK: - TableView Management

//input: none
//output: manages various properties of the tableView and how objects will be populated and displayed
//Protocol for managing the populating of the tableView
extension ChatViewController: UITableViewDataSource {
    
    //input: none
    //output: determines how many rows of the tableView to populate with data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //input: none
    //output: Populates the tableView with custom tableView cells that will look like chat bubbles
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



