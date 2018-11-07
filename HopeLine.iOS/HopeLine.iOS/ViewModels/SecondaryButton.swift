//
//  SecondaryButton.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class SecondaryButton: UIButton {
    override func draw(_ rect: CGRect) {
        let primarybg = UIColor(red: CGFloat(89)/225, green: CGFloat(103)/225, blue: CGFloat(132)/225, alpha: CGFloat(1))
        let primarytxt  = UIColor(red: CGFloat(225)/225, green: CGFloat(225)/225, blue: CGFloat(225)/225, alpha: CGFloat(1))
        super.draw(rect)
        self.layer.borderWidth = 5
        self.layer.borderColor = primarybg.cgColor
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = primarybg.cgColor
        self.setTitleColor(primarytxt, for: .normal)
    }

}
