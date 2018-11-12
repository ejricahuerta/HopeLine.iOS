//
//  Community.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class Community: NSObject {
    var id : Int?
    var name : String?
    var desc : String?
    var url : String?
    var imgUrl : String?

    init(id: Int? , name: String, desc : String, url : String, img : String) {
        self.id = id
        self.name = name
        self.desc = desc
        self.url = url
        self.imgUrl = img
    }
}
