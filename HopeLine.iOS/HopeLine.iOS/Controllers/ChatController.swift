//
//  ChatController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class ChatController: UIViewController , UITableViewDelegate, UITableViewDataSource, HubConnectionDelegate , ViewDismiss{
    
    
    
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
        //table
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        //signalr
        self.registerMethods()
        
  
        //timer = Timer.init(timeInterval: 0.5, target: self, selector: #selector(connectionRequest), userInfo: nil, repeats: true)
        self.chatHubConnection?.invoke(method: "RequestToTalk", arguments: [currentUser], invocationDidComplete: { err in
            if let resp = err {
                print("Error...\(String(describing: resp))")
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rateSegue" {
            let view = segue.destination as! RateController
            view.dismissDelegate = self
        }
    }
    
    
    func didRate(isDone: Bool) {
        self.navigationController?.popToRootViewController(animated: true)

        //self.navigationController?.popToRootViewController(animated: false)
    }
    
    //TABLE VIEW
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        let message = messages.object(at: indexPath.row) as! Message
        let msgcolor = getColorFor(username : message.user!)
        cell.setUp(name: message.user!, msg: message.message!,color: msgcolor)
        
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
                print("Error on : \(String(describing: resp))")
            }
        })
    }
   
    //register all methods from hub server
    func registerMethods(){
        chatHubConnection?.on(method: "NotifyUser",  callback: {args, typeConverter in
            let id = try! typeConverter.convertFromWireType(obj: args[0], targetType: Int.self)
            print("ID: \(id!)")
            switch id! {
                case ChatConnection.Connected.rawValue:
                    self.sendButton.isHidden = false
                    self.chatText.isHidden = false
                    break
                case ChatConnection.Error.rawValue:
                    self.alert = UIAlertController(title: nil, message: "Error while Matching Mentor", preferredStyle: UIAlertControllerStyle.alert)
                    self.alert?.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: { (act) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(self.alert!, animated: true, completion: nil)
                    break
                case ChatConnection.MatchingMentor.rawValue:
                    self.alert = UIAlertController(title: nil, message: "Matching Mentor", preferredStyle: UIAlertControllerStyle.alert)
                    self.alert?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (act) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(self.alert!, animated: true, completion: nil)
                    break
                default:
                    break
            }
            
        })
        
        self.chatHubConnection?.on(method: "ReceiveMessage", callback: { args, typeConverter in
            self.didGetMessage(args: args, converter: typeConverter)
        })
        
        self.chatHubConnection?.on(method: "Room", callback: { args, typeConverter in
            self.room = (try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self))!
            self.alert?.dismiss(animated: true, completion: nil)
            self.sendButton.isHidden = false
            self.chatText.isHidden = false
            print("ROOM : \(self.room)")
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
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)

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
    
    func getColorFor(username : String?) -> UIColor{
        print(username!)
        if username! == currentUser! {
            return usercolor
        }
        else if username == "system" {
            return syscolor
        }
        else {
            return mentorcolor
        }
    }
    
    
    //keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}



