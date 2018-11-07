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
     private let bordercolor  = UIColor(red: CGFloat(63)/255, green: CGFloat(76)/255, blue: CGFloat(163)/255, alpha: CGFloat(1))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.borderColor = self.bordercolor.cgColor
    }
}
