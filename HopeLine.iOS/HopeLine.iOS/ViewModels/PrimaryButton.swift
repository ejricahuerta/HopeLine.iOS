//
//  PrimaryButton.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-02.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        self.layer.borderWidth = 5
        self.layer.borderColor = primarybg.cgColor
        self.layer.cornerRadius = 5
        self.layer.backgroundColor = primarybg.cgColor
        self.setTitleColor(primarytxt, for: .normal)
    }
}
