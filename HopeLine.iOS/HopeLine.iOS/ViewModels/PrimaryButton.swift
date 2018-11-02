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
        let primarybg = UIColor(red: CGFloat(40)/255, green: CGFloat(37)/255, blue: CGFloat(117)/255, alpha: CGFloat(1))
        let primarytxt  = UIColor(red: CGFloat(178)/255, green: CGFloat(176)/255, blue: CGFloat(222)/255, alpha: CGFloat(1))
        super.draw(rect)
        self.layer.borderWidth = 5
        self.layer.borderColor = primarybg.cgColor
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = primarybg.cgColor
        self.setTitleColor(primarytxt, for: .normal)
    }
}
