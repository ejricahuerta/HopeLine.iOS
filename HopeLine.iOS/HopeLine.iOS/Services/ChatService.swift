
//
//  ChatService.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-09.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class ChatService {
    var chatConnection : HubConnection?
    func connect(connection : HubConnection?) -> Void {
        if connection != nil {
            self.chatConnection = connection
        }
    }
}
