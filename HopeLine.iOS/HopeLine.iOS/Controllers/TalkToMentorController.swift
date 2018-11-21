//
//  TalkToMentorController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class TalkToMentorController: UIViewController , HubConnectionDelegate, MentorDelegate{

    @IBOutlet weak var notif: UILabel!
    
    var timer : Timer?
    var user : String?
    
    var chatHubConnection : HubConnection?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notif.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBarItem.badgeValue = "1"
        
        user = "Guest" + String.random(length: 12)
        chatHubConnection =   HubConnectionBuilder(url: URL(string:"https://hopelineapi.azurewebsites.net/v2/chatHub")!)
                .withLogging(minLogLevel: .debug)
            .build()
        self.chatHubConnection!.start()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.contains("chatSegue"))! {
            let view = segue.destination as! ChatController
            view.chatHubConnection = self.chatHubConnection
            view.currentUser = user
            view.mentordelegate = self
        }
        else {
            let _ = segue.destination as! TemporaryController
        }
        
    }
    func didNotFindMentor() {
        var counter = 0
        self.notif.isHidden = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if counter < 10 {
                counter += 1
            }
            else {
                self.notif.isHidden = true
                self.timer?.invalidate()
                
            }
        })
    }
    
    
    func connectionDidOpen(hubConnection: HubConnection!) {
        //FIXME
    }
    
    func connectionDidFailToOpen(error: Error) {
        print(error.localizedDescription)
        chatHubConnection?.start()
    }
    
    func connectionDidClose(error: Error?) {
             //FIXME
    }
    
}


