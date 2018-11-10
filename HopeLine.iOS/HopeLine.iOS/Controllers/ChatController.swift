//
//  ChatController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class ChatController: UIViewController , UITableViewDelegate, UITableViewDataSource, HubConnectionDelegate {
    
    
    
    
    var messages = NSMutableArray()
    var chatHubConnection: HubConnection?
    var room : String  = ""
    var currentUser : String?
    var isConnected : Bool?
    var timer : Timer?
    var counter = 0
    var notif : String?

    var alert  : UIAlertController?
    
    @IBOutlet weak var chatText: PrimaryText!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var sendButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CURRENT USER: \(currentUser!)")
        

        
        //components
        self.sendButton.isHidden = true
        self.chatText.isHidden = true
        //table
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100.0;
        
        //signalr
        
        self.registerMethods()
        
  
        //timer = Timer.init(timeInterval: 0.5, target: self, selector: #selector(connectionRequest), userInfo: nil, repeats: true)
        self.chatHubConnection?.invoke(method: "RequestToTalk", arguments: [currentUser], invocationDidComplete: { err in
            if let resp = err {
                print("Error...\(String(describing: resp))")
            }
        })
    }
    
 
    
    @IBAction func sentMesage(_ sender: PrimaryButton) {
        if textMessage.text?.isEmpty  == false {
            let newmsg = textMessage.text
            print(" USER : \(String(describing: currentUser))")
            print(" MESSAGE : \(String(describing: newmsg))")
            print(" ROOM : \(room)")
            
            chatHubConnection?.invoke(method:"SendMessage", arguments: [currentUser!,newmsg!, room], invocationDidComplete: { (err) in
                if let resperr = err {
                    print("Error on sending ... :\(String(describing: resperr.localizedDescription)) ")
                }
            })
        }
        self.chatText.text = ""
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        let message = messages.object(at: indexPath.row) as! Message
        cell.setUp(name: message.user!, msg: message.message!)
        return cell
    }
    
    //SignalR Swift
 
    func connectionDidOpen(hubConnection: HubConnection!) {
        
    }
    
    func connectionDidFailToOpen(error: Error) {
    }
    
    func connectionDidClose(error: Error?) {
        
        
        let user  = "system"
        let message = "User left the chat."
        self.chatHubConnection?.invoke(method: "SendMessage", arguments: [user,message], invocationDidComplete: { (err) in
            if let resp = err {
                print("Error on : \(err)")
            }
        })
    }
    
    
    
    
    //register all methods from hub server
    func registerMethods(){
        
        chatHubConnection?.on(method: "NotifyUser",  callback: {args, typeConverter in
            let message = try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self)
            if message != "Connected" {
                self.alert = UIAlertController(title: "Matching Mentor", message: message, preferredStyle: UIAlertControllerStyle.alert)
                self.alert?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (act) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(self.alert!, animated: true, completion: nil)
            }

        })
        
        self.chatHubConnection?.on(method: "ReceiveMessage", callback: { args, typeConverter in
            self.didGetMessage(args: args, converter: typeConverter)
        })
        
        self.chatHubConnection?.on(method: "Room", callback: { args, typeConverter in
            self.room = (try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self))!
            if self.alert!.isViewLoaded {
                self.alert?.dismiss(animated: true, completion: nil)
            }
            print("ROOM : \(self.room)")
            self.sendButton.isHidden = false
            self.chatText.isHidden = false
            self.title = "You are now connected!"
            self.chatHubConnection?.invoke(method: "LoadMessage", arguments: [self.room], invocationDidComplete: { (err) in
                if let resperr = err {
                    print(resperr)
                }
            })

        })
        
        self.chatHubConnection?.on(method: "Load", callback: { args, typeConverter in
            self.didGetMessage(args: args, converter: typeConverter)
        })

    }
    
    //Get Data and reload Table
    private func didGetMessage(args :[Any?], converter: TypeConverter) {
        let user = (try! converter.convertFromWireType(obj: args[0], targetType: String.self))!
        let message = (try! converter.convertFromWireType(obj: args[1], targetType: String.self))!
        let newMessage = Message(user: user, message: message)
        self.messages.add(newMessage)
        self.tableView.reloadData()
    }
    
    
    //Request Time
    @objc func connectionRequest(){
        print("Attempting to Connect to a Mentor - attempt: \(counter)")
        self.chatHubConnection?.invoke(method: "RequestToTalk", arguments: [currentUser], invocationDidComplete: { err in
            if let resp = err {
                print("Error...\(String(describing: resp))")
            }
        })
        counter += 1
        print("Attempting to Connect to a Mentor - attempt: \(counter)")
    }

}




