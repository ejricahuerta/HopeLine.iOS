//
//  ChatController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class ChatController: UIViewController , UITableViewDelegate, UITableViewDataSource , ConnectionDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sendButton: SecondaryButton!
    var chatHubConnection: HubConnection?
    @IBAction func Send(_ sender: Any) {
        self.chatHubConnection?.invoke(method: "RequestToTalk", arguments: ["Guest24sdg3"], invocationDidComplete: { err in
            print("Error...\(err)")
            self.sendButton.isHidden = false
        })
    }
    
    override func viewDidLoad() {
        chatHubConnection =  HubConnectionBuilder(url: URL(string:"https://hopelineapi.azurewebsites.net/v2/chatHub")!)
            .withLogging(minLogLevel: .debug)
            .build()
        
        
        chatHubConnection?.on(method: "NotifyUser",  callback: {args, typeConverter in
            let message = try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self)
            if (message?.contains("Connected."))! {
                DispatchQueue.main.async {
                    print("You are connected... ")
                }
            }
            
        })
        self.chatHubConnection!.start()
        super.viewDidLoad()
        

    }
    func connectionDidClose(error: Error?) {
        self.connectionDidClose(error: error)
        print("Error... \(String(describing: error?.localizedDescription))")
    }
    
    func connectionDidOpen(connection: Connection!) {
        
    }

    func connectionDidFailToOpen(error: Error) {
        print("connection Stopped.")
    }
    
    func connectionDidReceiveData(connection: Connection!, data: Data) {
        print(data)
        print("Data here")
    }
    
    var messages = NSMutableArray()
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        return cell
    }
}




