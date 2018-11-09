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
        user = "Guest" + String.random(length: 12)
        chatHubConnection =   HubConnectionBuilder(url: URL(string:"https://hopelineapi.azurewebsites.net/v2/chatHub")!)
                .withLogging(minLogLevel: .debug)
                .build()
        
        chatHubConnection?.on(method: "NotifyUser",  callback: {args, typeConverter in
            let message = try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self)
            if (message?.contains("Connected."))! {
                print("You are connected... ")
            }
        })
        
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

extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
