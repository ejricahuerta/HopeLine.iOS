//
//  ChatController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit


protocol MentorDelegate {
   func didNotFindMentor() -> Void
}

class ChatController: UIViewController , UITableViewDelegate, UITableViewDataSource, HubConnectionDelegate , ViewDismiss , UITextFieldDelegate {

    private var offset : CGFloat = 0
    private var keyboardVisibleHeight : CGFloat = 0
    var messages = NSMutableArray()
    var chatHubConnection: HubConnection?
    var room : String  = ""
    var currentUser : String?
    var isConnected : Bool?
    var timer : Timer?
    var counter = 0
    var notif : String?
    var mentordelegate : MentorDelegate?
    var alert  : UIAlertController?
    
    @IBOutlet weak var chatText: PrimaryText!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var sendButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        print("CURRENT USER: \(currentUser!)")
        //table
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        //signalr
        self.registerMethods()
        self.chatHubConnection?.invoke(method: "RequestToTalk", arguments: [currentUser], invocationDidComplete: { err in
            if let resp = err {
                print("Error...\(String(describing: resp))")
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rateSegue" {
            let view = segue.destination as! RateController
            view.dismissDelegate = self
        }
    }
    
    @IBAction func sentMesage(_ sender: PrimaryButton) {
        self.sentAMessage()
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
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.chatText.endEditing(true)
        return nil
    }
    
    //TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sentAMessage()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2000
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    
    //SignalR Swift delegate
    func connectionDidOpen(hubConnection: HubConnection!) {
        
    }
    
    func connectionDidFailToOpen(error: Error) {
        self.alert = UIAlertController(title: nil, message: "Error while Matching Mentor", preferredStyle: UIAlertControllerStyle.alert)
        self.alert?.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.cancel, handler: { (act) in
            self.chatHubConnection?.start()
        }))
        self.present(self.alert!, animated: true, completion: nil)
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
                        self.timer?.invalidate()
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    
                    self.present(self.alert!, animated: true, completion: nil)
                    break
                case ChatConnection.MatchingMentor.rawValue:
                    self.alert = UIAlertController(title: nil, message: "Matching Mentor", preferredStyle: UIAlertControllerStyle.alert)
                    self.alert?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (act) in
                        if self.timer != nil {
                            self.timer?.invalidate()
                        }
                    self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(self.alert!, animated: true, completion: nil)
                    var counter = 0
                    
                    self.timer  = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                        if counter == 10 {
                            self.alert?.message = "Retrying..."
                        }
                        if counter == 20 {
                            timer.invalidate()
                            self.alert?.dismiss(animated: true, completion: {
                                self.mentordelegate?.didNotFindMentor()
                                self.navigationController?.popToRootViewController(animated: true)
                            })

                        }
                        counter += 1
                        
                        print("Counter : \(counter)")
                    })

                    break
                default:
                    break
            }
    
        })
        
        self.chatHubConnection?.on(method: "ReceiveMessage", callback: { args, typeConverter in
            self.didGetMessage(args: args, converter: typeConverter)
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        })
        
        self.chatHubConnection?.on(method: "Room", callback: { args, typeConverter in
            self.room = (try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self))!
            self.timer?.invalidate()
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
            self.didGetMessage( args: args, converter: typeConverter)
            self.timer?.invalidate()
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        })
    }

    //Get Data and reload Table
    private func didGetMessage(args :[Any?], converter: TypeConverter) {
        let user = (try! converter.convertFromWireType(obj: args[0], targetType: String.self))!
        let message = (try! converter.convertFromWireType(obj: args[1], targetType: String.self))!
        let newMessage = Message(user: user, message: message)
        self.messages.add(newMessage)
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

    //setting color for user
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
    
    //setting uialert
    func setUpAlert(title: String?, msg : String?)  {
        
    }
    
    @objc func endTextEdit(){
        self.chatText.endEditing(true)
    }

    func sentAMessage() {
        if textMessage.text?.isEmpty  == false {
            let newmsg = textMessage.text
            print(" USER : \(String(describing: currentUser))")
            print(" MESSAGE : \(String(describing: newmsg))")
            print(" ROOM : \(room)")
            
            chatHubConnection?.invoke(method:"SendMessage", arguments: [currentUser!,newmsg!, room], invocationDidComplete: { (err) in
                if let resperr = err {
                    
                    //fixme : change to an alert or custom toast
                    print("Error on sending ... :\(String(describing: resperr.localizedDescription)) ")
                }
            })
        }
        self.chatText.text = ""
    }
    
    func didRate(isDone: Bool) {
        self.chatHubConnection?.invoke(method: "RemoveUser", arguments: [currentUser,room,true], invocationDidComplete: { (err) in
            if let resp = err {
                print("Error on : \(String(describing: resp))")
            }
        })
        self.navigationController?.popToRootViewController(animated: true)
        
        //self.navigationController?.popToRootViewController(animated: false)
    }
}



