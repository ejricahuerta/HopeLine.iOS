//
//  Topics.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-02.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class Topics: Decodable {
    
    var Name: String
    var Desc : String
    
    init?(name : String , desc: String)
    {
        Name = name
        Desc = desc
    }
}
