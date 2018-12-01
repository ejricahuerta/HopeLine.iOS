//
//  Notification.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-12-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class Notification: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.layer.opacity = 0.9
        self.layer.masksToBounds = true
    }

}
