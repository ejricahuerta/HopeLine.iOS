//
//  ChatText.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-08.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class ChatText: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
    

}
