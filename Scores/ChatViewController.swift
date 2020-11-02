//
//  ChatViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 10/24/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import CoreData
import Firebase
//import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var teamInfo: TeamRecord?
    // Declare instance variables here
    var messageArr : [Message] = [Message]()
    let db = Firestore.firestore()
    // Control height constraints of messenger section
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    // For the send button
    var sendButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 150, y: UIScreen.main.bounds.maxY-200, width: 125, height: 50))
    // Message storage
    var messageTextfield = UITextField(frame: CGRect(x: 20, y: UIScreen.main.bounds.maxY-200, width: UIScreen.main.bounds.width - 200, height: 50))
    // Table
    var messageTableView = UITableView()
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: teamColors[teamInfo!.team]![0])
        messageTableView.dataSource = self
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            let savedInfo = try managedContext.fetch(fetchRequest)
            if savedInfo.count > 0 {
                let currentUser: NSManagedObject = savedInfo[savedInfo.count - 1]
                self.username = currentUser.value(forKey: "username") as? String
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        // lets you know when tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        messageTableView.backgroundColor = UIColor(hex: teamColors[teamInfo!.team]![0])
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        messageTextfield.backgroundColor = .white
        messageTextfield.layer.cornerRadius = 10
        view.addSubview(messageTextfield)
        
        sendButton.titleLabel!.text = "Send"
        sendButton.backgroundColor = .darkGray
        sendButton.titleLabel?.textColor = .white
        sendButton.layer.cornerRadius = 15
        sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        view.addSubview(sendButton)
        view.bringSubviewToFront(sendButton)
        
        
    }
    
    //MARK: - TableView DataSource Methods
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        // User settings default
        cell.messageBody.text = messageArr[indexPath.row].message
        cell.senderUsername.text = messageArr[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "bull")
        // if looking at own message from own phone
        if(username != nil && cell.senderUsername.text == username){
            // Own message showing
            cell.avatarImageView.backgroundColor = UIColor.systemGray
            cell.messageBackground.backgroundColor = UIColor.systemGreen
        }
        // if viewing other person's message
        else{
            cell.avatarImageView.backgroundColor = UIColor.systemBlue
            cell.messageBackground.backgroundColor = UIColor.systemGray
        }
        return cell
    }
    
    
    // Simple function to return number of messages
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    // Use this call to escape keyboard
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    // simple tableview settings
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.messageTableView)
        setTableViewDelegates()
        self.messageTableView.estimatedRowHeight = 120
        self.messageTableView.pin(to: view)
    }
    
    //MARK:- TextField Delegate Methods
    
    

    
    // Move keyboard when you want to type
    func textFieldDidBeginEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.4){
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            
        }
    }
    
    // remove keyboard when done with typing AKA clicking somewhere else
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    func setTableViewDelegates() {
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
    }

    
    //MARK: - Send & Recieve from Firebase
    @objc
    func sendPressed(sender: UIButton) {
        print("Pushed Button")
        if(self.username == nil) {
            print("User was nil, so can't post")
            return
        }
        // Sending messages to Firebase DB
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        
        if let messageBody = messageTextfield.text, let messageSender = self.username {
            db.collection(self.teamInfo!.team).addDocument(data: [
                "sender" : messageSender,
                "body" : messageBody,
                "dateField" : Date().timeIntervalSince1970
            ]) { (error) in
                if error != nil {
                    print("Issue occurred when saving data to firestore")
                } else {
                    print("Successfully saved data")
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    // this function retreieves messages to showcase
    func retrieveMessages() {
        db.collection(self.teamInfo!.team)
            .order(by: "dateField")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messageArr = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                            let newMessage = Message()
                            newMessage.message = messageBody
                            newMessage.sender = messageSender
                            self.messageArr.append(newMessage)
                            
                            DispatchQueue.main.async {
                                   self.messageTableView.reloadData()
                                let indexPath = IndexPath(row: self.messageArr.count - 1, section: 0)
                                self.messageTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
}
