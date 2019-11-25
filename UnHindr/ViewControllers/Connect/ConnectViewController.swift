/*
 File: [ConnectViewController.swift]
 Creators: [Sina]
 Date created: [16/11/2019]
 Date updated: [16/11/2019]
 Updater name: [Sina]
 File description: [Controls connectivity features]
 */

import UIKit
import FirebaseFirestore

public var user_ID: String = ""
var list: [String] = []

class ConnectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let connectionRef = Services.fullUserRef.document(Services.userRef!).collection(Services.connectionName)
    
    var connectionSnapshot: QuerySnapshot?
    
    @IBOutlet weak var connectionsTable: UITableView!
    @IBOutlet weak var connectEmail: UITextField!
    
    //list of user's connections
//    var list = [""]

    //determines number of sections for UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //set number of rows in for UITableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPatient = list[indexPath.row] as! String
        print(selectedPatient)
        getRefFromEmail(selectedPatient) { (ref) in
            if ref != "" {
                user_ID = ref
            }
        }
    }
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //apply the magnifying glass image to the search bar
        let mailImage = UIImage(named: "search1")
        addImageLeftSide(txtField: connectEmail, andImage: mailImage!)
        connectionsTable.dataSource = self
        connectionsTable.delegate = self
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        getConnections(Services.userRef!) { (querySnapshot) in
            for document in querySnapshot!.documents {
                list.append(document.get("email") as! String)
                self.connectionsTable.beginUpdates()
                self.connectionsTable.insertRows(at: [
                    NSIndexPath(row: list.count-1, section: 0) as IndexPath], with: .automatic)
                self.connectionsTable.endUpdates()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        list.removeAll()
    }
    
    
    // MARK: - Transitioning to home page
    // Input:
    //      1. sender
    // Output:
    //      1. transition to the correct home page based on user's mode
    @IBAction func homeButtonTapped(_ sender: Any) {
        Services.transitionHome(self)
    }
    
    
    
    // Input:
    //      1. unique UID of a user
    // Output:
    //      1. Reference to connection
    func getConnections(_ userdoc: String, completionHandler: @escaping (_ result: QuerySnapshot? ) -> Void){
        connectionRef.getDocuments { (querySnapshot, error) in
            if error != nil {
                //error
            }
            else{
                guard let query = querySnapshot else {
                    print("Error fetching user document")
                    return
                }
                completionHandler(query)
            }
        }
    }
    
    
    // MARK: - Segue functions for adding new connections
    // UI Component
    // Activation: When pressed
    // Action: If successful -> new connection added to user
    @IBAction func checkTapped(_ sender: UIButton) {
        // Check to see if email has a valid input
        self.getPairedUID { (querySnapshot) in
            if (querySnapshot?.isEmpty)! {
                // Unable to find user
            }
            else {
                // Add to connections firestore
                let pairedUID = querySnapshot!.documents[0].get("uid") as! String
                let pairedEmail = querySnapshot!.documents[0].get("email") as! String
                
                //update the global connection variable
                otherUID = pairedUID
                
                self.checkPairable(pairedEmail, completionHandler: { (ret) in
                    if ret {
                        self.storeToDB(pairedUID, pairedEmail)
                    } else {
                        // Display an error message
                        Services.showAlert("You're already paired with \(pairedEmail)", "", vc: self)
                    }
                })
            }
        }

    }
    
    // Input:
    //      1. Data that is guaranteed to be storable
    // Output:
    //      1. Store user pair information for the current user
    private func storeToDB(_ pairedUID: String, _ pairedEmail: String){
        var ref: DocumentReference? = nil
        ref = connectionRef.addDocument(data: [
            "uid": pairedUID,
            "email": pairedEmail
        ]){err in
            if let err = err {
                print("Error adding document: \(err)")
            }else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // Check to see if the connection already exists in the current user
    private func checkPairable(_ email: String, completionHandler: @escaping (_ result: Bool) -> Void) {
        connectionRef.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, err) in
            if err != nil {
                // Error
            } else {
                if ((querySnapshot?.isEmpty)!) {
                    completionHandler(true)
                }
                else {
                    completionHandler(false)
                }
            }
        }
    }
    
    // Input:
    //
    // Output:
    //      1. Gets The pairs UID based on email
    private func getPairedUID(completionHandler: @escaping (_ result: QuerySnapshot?) -> Void) {
        Services.fullUserRef.whereField("email", isEqualTo: connectEmail.text!).getDocuments { (querySnapshot, err) in
            if err != nil {
                // error
            } else {
                if querySnapshot!.isEmpty {
                    Services.showAlert("The Entered Email Does not Exist!", "", vc: self)
                }
                completionHandler(querySnapshot!)
            }
        }
    }
    
    //Input1: The text field which image should apply to
    //input2: The inserting image reference
    func addImageLeftSide(txtField: UITextField, andImage img: UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 100, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
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
