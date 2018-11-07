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
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var chatHubConnection: HubConnection?
        chatHubConnection =  HubConnectionBuilder(url: URL(string:"https://hopelineapi.azurewebsites.net/v2/chatHub")!)
            .withLogging(minLogLevel: .debug)
            .build()
        
        chatHubConnection?.start()
        let user  = "Guest13rdf34"
        chatHubConnection?.invoke(method: "RequestToTalk", arguments: [user], invocationDidComplete: { (err) in
            print("Error\(err!)")
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
        
        return cell  = self.tableView.dequeueReusableCell(withIdentifier: "commonCell", for: indexPath) as! Chat
        
    }
    
    
}


