//
//  Resource.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class Resource: NSObject {
    var id : String?
    var name : String?
    var url : String?
    var imageUrl : String?
    
    init(id: String, name : String, url: String, imageUrl : String) {
        self.id = id
        self.name = name
        self.url = url
        self.imageUrl = imageUrl
    }
}
