//
//  PrimaryText.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-02.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class PrimaryText: UITextField, UITextFieldDelegate {
    
    
    //Move to own file

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.borderColor = bordercolor.cgColor
    }
}
