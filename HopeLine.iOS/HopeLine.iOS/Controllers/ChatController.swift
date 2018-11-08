//
//  ChatController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class ChatController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var messages = NSMutableArray()
    var chatHubConnection: HubConnection?
    var room : String  = ""
    var currentUser : String?
    var nameService = NameGeneratorService()
    var queue = DispatchQueue(label: "chat queue")
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: SecondaryButton!
    @IBOutlet weak var textMessage: UITextField!
    
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = "Guest3aet"
        print("CURRENT USER: \(currentUser!)")
        
        self.chatHubConnection?.on(method: "Room", callback: { args, typeConverter in
            self.room = (try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self))!
            print("ROOM : \(self.room)")
            self.chatHubConnection?.invoke(method: "LoadMessage", arguments: [self.room], invocationDidComplete: { (err) in
                if let resperr = err {
                    print(resperr)
                }
            })
        })
        
        self.chatHubConnection?.on(method: "Load", callback: { args, typeConverter in
            let user = (try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self))!
            let message = (try! typeConverter.convertFromWireType(obj: args[1], targetType: String.self))!
            let newMessage = Message(user: user, message: message)
            self.messages.add(newMessage)
            self.tableView.reloadData()
        })
        
        self.chatHubConnection?.on(method: "ReceiveMessage", callback: { args, typeConverter in
            let user = (try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self))!
            let message = (try! typeConverter.convertFromWireType(obj: args[1], targetType: String.self))!
            let newMessage = Message(user: user, message: message)
            self.messages.add(newMessage)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })
    
        self.chatHubConnection?.invoke(method: "RequestToTalk", arguments: [currentUser], invocationDidComplete: { err in
            print("Error...\(String(describing: err))")
        })
    }
    
    
    @IBAction func sentMesagae(_ sender: PrimaryButton) {
        let newmsg = textMessage.text
        print(" USER : \(currentUser)")
        print(" MESSAGE : \(newmsg)")
        print(" ROOM : \(room)")
        
        chatHubConnection?.invoke(method:"SendMessage", arguments: [currentUser!,newmsg!, room], invocationDidComplete: { (err) in
            if let resperr = err {
                print("Error on sending ... :\(String(describing: resperr.localizedDescription)) ")
            }
        })

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        let message = messages.object(at: indexPath.row) as! Message
        cell.setUp(name: message.user!, msg: message.message!)
        cell.detailTextLabel?.text = message.user
        return cell
    }
}




