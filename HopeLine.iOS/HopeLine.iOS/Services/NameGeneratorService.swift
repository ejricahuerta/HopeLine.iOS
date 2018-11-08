//
//  NameGeneratorService.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-08.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class NameGeneratorService: NSObject {
    private let guest = "Guest"
    private  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    func returnedGuestName() -> String {
        let len = String.Index(encodedOffset: 8)
        let randomStr = UUID.init()
        return "\(String(describing: randomStr))"
    }
}
