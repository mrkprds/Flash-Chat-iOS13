//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var messagelistener: ListenerRegistration? = nil
    
    var messages: [Message] = []
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessage()
        messageTextfield.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.messageCellNibName, bundle: nil), forCellReuseIdentifier: K.messageCellIdentifier)
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageTextfield.becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        messagelistener?.remove()
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sendMessage()
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func fetchMessage() {
        messagelistener =  db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, err) in
                
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }else{
                for snapshot in querySnapshot!.documentChanges{
                    let documentSnapshot = snapshot.document.data()
                    if let sender = documentSnapshot[K.FStore.senderField] as? String,
                        let body   = documentSnapshot[K.FStore.bodyField] as? String,
                        let date = documentSnapshot[K.FStore.dateField] as? Double{
                        self.messages.append(Message(sender: sender, body: body, date: date))
                    }
                }
            }
                
            DispatchQueue.main.async{
                self.tableView.reloadData()
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func sendMessage(){
        if let messageBody = messageTextfield.text, !messageBody.isEmpty,
            let sender     = Auth.auth().currentUser?.email {
            let date       = NSDate().timeIntervalSince1970
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: sender, K.FStore.bodyField: messageBody, K.FStore.dateField: date ]) { (err) in
                if let err = err{
                    print(err.localizedDescription)
                }else{
                    print("success")
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.messageCellIdentifier , for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.messageText?.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email{
            cell.senderImage.isHidden = false
            cell.receiverImage.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.textLabel?.textColor = UIColor(named: K.BrandColors.lightPurple)
            
            
        }else{
            cell.senderImage.isHidden = true
            cell.receiverImage.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.blue)
            cell.textLabel?.textColor = UIColor(named: K.BrandColors.lighBlue)
        }
        
        return cell
        
    }
}

extension ChatViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        messageTextfield.text = ""
        return true
    }
    
}
