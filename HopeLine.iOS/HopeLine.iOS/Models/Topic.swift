//
//  Topic.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class Topic: NSObject {

    var id : String?
    var name : String?
    var desc : String?
    
    init(id : String, name : String, desc : String) {
        self.id = id
        self.name = name
        self.desc = desc
    }
}
