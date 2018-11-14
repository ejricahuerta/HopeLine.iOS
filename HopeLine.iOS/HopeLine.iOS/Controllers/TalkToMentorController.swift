//
//  TalkToMentorController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class TalkToMentorController: UIViewController {
    
    var user : String?
    
    var chatHubConnection : HubConnection?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBarItem.badgeValue = "1"
        
        user = "Guest" + String.random(length: 12)
        chatHubConnection =   HubConnectionBuilder(url: URL(string:"https://hopelineapi.azurewebsites.net/v2/chatHub")!)
                .withLogging(minLogLevel: .debug)
                .build()
        self.chatHubConnection!.start()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.contains("chatSegue"))! {
            let view = segue.destination as! ChatController
            view.chatHubConnection = self.chatHubConnection
            view.currentUser = user
        }
    }
    
}


