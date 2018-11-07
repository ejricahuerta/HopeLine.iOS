//
//  Resource.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class Resource: NSObject {
    var id : Int?
    var name : String?
    var url : String?
    var desc : String?
    
    init(id: Int, name : String,desc : String, url: String) {
        self.id = id
        self.name = name
        self.desc = desc
        self.url = url
    }
}
