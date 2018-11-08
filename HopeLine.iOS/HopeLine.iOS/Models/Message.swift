//
//  Message.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var user : String?
    var message : String?
    
    init(user: String, message : String) {
        self.user = user
        self.message = message
    }
}
